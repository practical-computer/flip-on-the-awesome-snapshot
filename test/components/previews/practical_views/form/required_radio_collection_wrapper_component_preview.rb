# frozen_string_literal: true

class PracticalViews::Form::RequiredRadioCollectionWrapperComponentPreview < ViewComponent::Preview
  def default
    organization = Organization.first
    user = organization.memberships.first.user

    @form = Organization::MembershipForm.new(
      current_organization: organization,
      current_user: user,
      membership: organization.memberships.first
    )

    render_with_template(locals: {form: @form})
  end
end
