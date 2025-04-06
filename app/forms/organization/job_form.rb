# frozen_string_literal: true

class Organization::JobForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include ActionPolicy::Behaviour
  include GooglePlaceHydration

  authorize :user, through: :current_user
  authorize :organization, through: :current_organization

  attr_accessor :current_user, :current_organization, :job, :name, :note, :status, :google_place

  validates :current_organization, presence: true, allow_blank: false, allow_nil: false
  validates :current_user, presence: true, allow_blank: false, allow_nil: false
  validate :can_manage_jobs?
  before_validation :build_note_if_present

  def initialize(attributes = {})
    super

    self.name ||= self.job&.name
    self.status ||= self.job&.status.presence || "active"
    self.google_place ||= self.job&.google_place

    self.google_place = hydrate_google_place(value: self.google_place)

    if self.job.present?
      self.job.name = name
      self.job.status = status
      self.job.google_place = google_place
    else
      self.job = current_organization.jobs.build(
        name: self.name,
        google_place: self.google_place,
        original_creator: current_user,
        status: :active
      )
    end

    if self.job.note.present?
      self.note ||= self.job.note.tiptap_document.to_json
    end
  end

  def save!
    validate!
    Organization::Job.transaction do
      self.job.save!
      save_note!
    end
  rescue ActiveRecord::RecordInvalid => e
    self.errors.merge!(e.record.errors)
    raise e
  end

  def save_note!
    if note.present? && self.job.note.present?
      self.job.note.save!
    else
      delete_job_note_if_blank_note
    end
  end

  def persisted?
    self.job.persisted?
  end

  def model_name
    self.job.model_name
  end

  def can_manage_jobs?
    return if allowed_to?(:manage?, job, with: Organization::JobPolicy)
    errors.add(:base, :cannot_manage_jobs)
  end

  def delete_job_note_if_blank_note
    return if note.present?
    return if self.job.note.nil?
    self.job.note.destroy!
  end

  def build_note_if_present
    return if note.blank?
    if self.job.note.nil?
      self.job.build_note(organization: current_organization, original_author: current_user)
    end

    self.job.note.tiptap_document = JSON.parse(note)
  end
end