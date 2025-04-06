# frozen_string_literal: true

class Organization::NoteForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include ActionPolicy::Behaviour

  authorize :user, through: :current_user
  authorize :organization, through: :current_organization

  attr_accessor :current_user, :current_organization, :note,
                :tiptap_document, :resource

  validates :current_organization, presence: true, allow_blank: false, allow_nil: false
  validates :current_user, presence: true, allow_blank: false, allow_nil: false
  validate :can_manage_notes?

  def initialize(attributes = {})
    super

    self.tiptap_document ||= self.note&.tiptap_document.to_json
    self.resource ||= self.note&.resource

    if self.note.present?
      update_existing_note
    else
      build_new_note
    end
  end

  def save!
    validate!
    self.note.save!
  rescue ActiveRecord::RecordInvalid => e
    self.errors.merge!(e.record.errors)
    raise e
  end

  def persisted?
    self.note.persisted?
  end

  def model_name
    self.note.model_name
  end

  def update_existing_note
    self.note.tiptap_document = parsed_tiptap_document
    self.note.resource = self.resource
  end

  def build_new_note
    self.note = current_organization.notes.build(
      tiptap_document: parsed_tiptap_document,
      resource: self.resource,
      original_author: current_user
    )
  end

  def parsed_tiptap_document
    return nil if self.tiptap_document.blank?
    return self.tiptap_document unless self.tiptap_document.kind_of?(String)
    JSON.parse(self.tiptap_document)
  end

  def resource_gid
    Organization::Note.sgid_for_resource(resource: resource)
  end

  def can_manage_notes?
    policy_check = allowance_to(:manage?, note, with: Organization::NotePolicy)
    return if policy_check.value

    errors.add(:base, :cannot_manage_notes)
  end
end