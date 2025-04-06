# frozen_string_literal: true

class PracticalViews::Form::FieldErrorsComponentPreview < ViewComponent::Preview
  def default
    organization = Organization.first
    user = organization.memberships.first.user

    @form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: ""
    )

    begin
      @form.save!
    rescue ActiveRecord::RecordInvalid => e
    end

    render_with_template(template: "practical_views/form/field_errors_component_preview/default", locals: {form: @form})
  end

  def no_errors
    organization = Organization.first
    user = organization.memberships.first.user

    @form = Organization::JobForm.new(
      current_organization: organization,
      current_user: user,
      name: ""
    )

    render_with_template(template: "practical_views/form/field_errors_component_preview/default", locals: {form: @form})
  end
end
