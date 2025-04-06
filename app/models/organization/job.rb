# frozen_string_literal: true

class Organization::Job < ApplicationRecord
  belongs_to :organization
  belongs_to :original_creator, class_name: "User"
  has_one :note, as: :resource, dependent: :destroy
  belongs_to :google_place, optional: true
  has_many :onsites, dependent: :destroy
  has_many :tasks, class_name: "JobTask", dependent: :destroy

  validates :name, presence: true,
                   allow_blank: false,
                   allow_nil: false,
                   uniqueness: {scope: :organization_id}

  validate :original_creator_has_membership_in_organization, on: :create
  validate :archiving_with_no_todo_tasks

  enum :status, {active: 0, archived: 1}, default: :active

  scope :scannable_ordering, -> { ascending_status.order(name: :asc) }
  scope :job_name_includes, ->(value){ where("LOWER(name) ILIKE LOWER(?)", "%#{value}%") }
  scope :ascending_status, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1], status) ASC")) }
  scope :descending_status, -> { order(Arel.sql("ARRAY_POSITION(ARRAY[0, 1], status) DESC")) }

  def can_be_archived?
    return tasks.todo.none?
  end

  protected

  def archiving_with_no_todo_tasks
    return unless self.status_changed?
    return unless self.archived?
    return if can_be_archived?
    errors.add(:status, :still_has_todo_tasks)
  end

  def original_creator_has_membership_in_organization
    return if organization.blank?
    return if original_creator.blank?
    return if OrganizationPolicy.new(organization, user: original_creator).apply(:show?)
    errors.add(:original_creator, :cannot_access_organization)
  end
end
