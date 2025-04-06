# frozen_string_literal: true

class Organization::OnsiteForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include ActionPolicy::Behaviour
  include GooglePlaceHydration
  include JobManageAuthorizationCheck

  authorize :user, through: :current_user
  authorize :organization, through: :current_organization
  authorize :job

  attr_accessor :current_user, :current_organization, :job,
                :onsite, :label, :priority, :status, :google_place

  validates :current_organization, presence: true, allow_blank: false, allow_nil: false
  validates :current_user, presence: true, allow_blank: false, allow_nil: false
  validates :job, presence: true, allow_blank: false, allow_nil: false
  validate :can_manage_onsites?

  def initialize(attributes = {})
    super

    self.job ||= self.onsite&.job
    self.label ||= self.onsite&.label
    self.priority ||= self.onsite&.priority || "regular_priority"
    self.status ||= self.onsite&.status || "draft"

    if self.onsite&.persisted?
      self.google_place ||= self.onsite&.google_place
    else
      self.google_place ||= self.job&.google_place
    end

    self.google_place = hydrate_google_place(value: self.google_place)

    if self.onsite.present?
      update_existing_onsite
    else
      build_new_onsite
    end
  end

  def save!
    validate!
    self.onsite.save!
  rescue ActiveRecord::RecordInvalid => e
    self.errors.merge!(e.record.errors)
    raise e
  end

  def persisted?
    self.onsite.persisted?
  end

  def model_name
    self.onsite.model_name
  end

  def normalize_new_onsite_status
    return unless self.onsite.done? || self.onsite.discarded?
    self.onsite.status = :draft
    self.status = :draft
  end

  def update_existing_onsite
    self.onsite.job = job
    self.onsite.label = label
    self.onsite.priority = priority
    self.onsite.status = status
    self.onsite.google_place = google_place
  end

  def build_new_onsite
    self.onsite = job.onsites.build(
      label: self.label,
      priority: self.priority,
      status: self.status,
      original_creator: current_user,
      google_place: google_place
    )

    normalize_new_onsite_status
  end

  def can_manage_onsites?
    job_can_manage?(policy_action: :manage_onsites?, cannot_manage_error_key: :cannot_manage_onsites)
  end
end