# frozen_string_literal: true

require 'digest'

class Organization::Note < ApplicationRecord
  belongs_to :organization
  belongs_to :original_author, class_name: "User"
  belongs_to :resource, polymorphic: true

  validates :tiptap_document, presence: true, allow_blank: false, allow_nil: false
  validate :original_author_has_membership_in_organization, on: :create
  validate :resource_part_of_organization

  scope :chronological, -> { order(created_at: :asc)}
  scope :reverse_chronological, -> { order(created_at: :desc) }

  def self.sgid_for_resource(resource:)
    resource.to_sgid(for: :note)
  end

  def self.resource_from_sgid(sgid:)
    GlobalID::Locator.locate_signed(sgid.to_s, for: :note)
  end

  protected

  def original_author_has_membership_in_organization
    return if organization.blank?
    return if original_author.blank?
    return if OrganizationPolicy.new(organization, user: original_author).apply(:show?)
    errors.add(:original_author, :cannot_access_organization)
  end

  def resource_part_of_organization
    return if organization.blank?
    return if resource.blank?
    return if resource.organization == organization
    errors.add(:resource, :cannot_access_organization)
  end
end
