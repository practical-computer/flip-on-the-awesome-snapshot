# frozen_string_literal: true

class Forms::MembershipInvitation::NewUserFromInvitationFormComponent < ApplicationComponent
  attr_accessor :form, :invitation_id

  def initialize(form:, invitation_id:)
    @form = form
    @invitation_id = invitation_id
  end

  def generic_errors_id
    helpers.dom_id(form, :generic_errors)
  end

  def form_wrapper(&block)
    helpers.webawesome_form_with(
      model: form,
      url: create_user_and_use_membership_invitation_url(invitation_id),
      method: :post,
      local: false,
      id: dom_id(form, :registration_form),
      html: {
        "aria-describedby": generic_errors_id
      },
      data: {
        type: :json,
        challenge_url: new_create_challenge_membership_invitation_url(invitation_id),
        credential_field_name: field_name(form.model_name.param_key, :passkey_credential),
        register_passkey_form: true
      },
      &block
    )
  end
end
