# frozen_string_literal: true

require "application_system_test_case"

class OrganizationsTest < ApplicationSystemTestCase
  test "can see all the user's organizations & navigate to an organization" do
    user = users.moonlighter
    assert_sign_in_user(user: user)

    visit organizations_url
    assert_current_path organizations_url

    assert_selector "h1", text: "Organizations"

    organizations = user.organizations.where(memberships: {state: :active})

    assert_not_empty organizations
    organizations.each do |organization|
      assert_selector "h2", text: organization.name
    end

    organization = organizations.first

    click_link organization.name
    assert_current_path organization_url(organization)
  end
end
