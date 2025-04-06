# frozen_string_literal: true

class Navigation::MainAppComponentPreview < ViewComponent::Preview
  def default
    organization = Organization.first
    user = organization.memberships.first.user
    render(Navigation::MainAppComponent.new(
      current_user: user,
      current_organization: organization
    ))
  end

  def only_one_organization
    user = User.find_by(email: "desiree@example.com")
    organization = user.organizations.first
    render(Navigation::MainAppComponent.new(
      current_user: user,
      current_organization: organization
    ))
  end

  def no_current_organization
    render(Navigation::MainAppComponent.new(
      current_user: User.first,
      current_organization: nil
    ))
  end
end
