# frozen_string_literal: true

class Organization::JobTask < ApplicationRecord
  belongs_to :job
  has_one :organization, through: :job
  belongs_to :onsite, optional: true
  belongs_to :original_creator, class_name: "User"

  validates :label, presence: true,
                   allow_blank: false,
                   allow_nil: false,
                   uniqueness: {scope: [:job_id, :onsite_id]}

  validate :original_creator_has_membership_in_organization, on: :create
  validate :onsite_is_for_job

  enum :task_type, { onsite: 0, offsite: 1 }, default: :onsite
  enum :status, { todo: 0, done: 1, cancelled: 2 }, default: :todo

  scope :scannable_ordering, -> {
    order(Arel.sql(
    <<~SQL
      ARRAY_POSITION(ARRAY[0, 1, 2], organization_job_tasks.status),
      ARRAY_POSITION(ARRAY[0, 1], task_type),
      label ASC
    SQL
    ))
  }

  scope :label_includes, ->(value){ where("LOWER(label) ILIKE LOWER(?)", "%#{value}%") }
  scope :ascending_task_type, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1], task_type) ASC")) }
  scope :descending_task_type, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1], task_type) DESC")) }
  scope :ascending_status, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1, 2], organization_job_tasks.status) ASC")) }
  scope :descending_status, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1, 2], organization_job_tasks.status) DESC")) }
  scope :ascending_onsite_label, -> { left_outer_joins(:onsite).order("organization_onsites.label ASC NULLS LAST") }
  scope :descending_onsite_label, -> { left_outer_joins(:onsite).order("organization_onsites.label DESC NULLS FIRST") }

  after_commit :break_caches

  protected

  def break_caches
    if onsite.present?
      Caching::BreakTaskCacheForOrganizationOnsiteJob.perform_later(onsite: onsite)
    end

    if onsite_id_previously_was.present?
      Caching::BreakTaskCacheForOrganizationOnsiteJob.perform_later(
        onsite: Organization::Onsite.find(onsite_id_previously_was)
      )
    end

    Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_later(job: job)

    if job_id_previously_was.present?
      Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_later(
        job: Organization::Job.find(job_id_previously_was)
      )
    end
  end

  def original_creator_has_membership_in_organization
    return if organization.blank?
    return if original_creator.blank?
    return if OrganizationPolicy.new(organization, user: original_creator).apply(:show?)
    errors.add(:original_creator, :cannot_access_organization)
  end

  def onsite_is_for_job
    return if onsite.blank?
    return if job.blank?
    return if onsite.job == job
    errors.add(:onsite, :not_in_job)
  end
end
