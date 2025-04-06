# frozen_string_literal: true

require "test_helper"

class Organization::NoteTest < ActiveSupport::TestCase
  def valid_new_note
    organizations.organization_1.notes.build(
      tiptap_document: {type: "doc", content: [{type: "text", contents: Faker::Lorem.sentence}]},
      original_author: users.organization_1_owner,
      resource: organization_jobs.repeat_customer
    )
  end

  test "belongs_to :resource" do
    reflection = Organization::Note.reflect_on_association(:resource)
    assert_equal true, reflection.polymorphic?
    assert_equal :belongs_to, reflection.macro
  end

  test "tiptap_document: must be present and non-blank" do
    note = valid_new_note

    assert_equal true, note.valid?

    note.tiptap_document = nil

    assert_equal false, note.valid?
    assert_equal true, note.errors.of_kind?(:tiptap_document, :blank)

    note.tiptap_document = {}

    assert_equal false, note.valid?
    assert_equal true, note.errors.of_kind?(:tiptap_document, :blank)
  end

  test "validates that the resource is in the organization" do
    note = valid_new_note
    other_resource = organization_jobs.new_customer_organization_2

    assert_not_equal other_resource.organization, note.organization

    note.resource = other_resource

    assert_equal false, note.valid?
    assert_equal true, note.errors.of_kind?(:resource, :cannot_access_organization)

    note.resource = organization_jobs.repeat_customer
    assert_equal true, note.valid?

    note.save!
  end

  test "validates that the original_author has a membership in the organization on creation only" do
    note = valid_new_note
    other_user = users.organization_3_owner

    assert_not_includes other_user.organizations, note.organization

    note.original_author = other_user

    assert_equal false, note.valid?
    assert_equal true, note.errors.of_kind?(:original_author, :cannot_access_organization)

    note.original_author = users.moonlighter
    assert_equal true, note.valid?

    note.original_author = users.organization_1_department_head
    assert_equal true, note.valid?

    note.save!

    note.original_author = users.organization_3_owner
    assert_equal true, note.valid?
  end

  test "sgid_for_resource/resource_from_sgid: generates a signed SGID for a given record with the :note purpose that expires in 1 month" do
    resource = organization_onsites.repeat_onsite_1

    sgid = Organization::Note.sgid_for_resource(resource: resource)
    assert_equal resource, Organization::Note.resource_from_sgid(sgid: sgid.to_s)

    other_sgid = resource.to_sgid(for: :other)
    assert_nil Organization::Note.resource_from_sgid(sgid: other_sgid.to_s)

    time = 3.months.from_now

    Timecop.freeze(time) do
      assert_nil Organization::Note.resource_from_sgid(sgid: sgid.to_s)
    end
  end
end
