# frozen_string_literal: true

class Administrator::EmergencyPasskeyRegistrationsController < DeviseController
  include Warden::WebAuthn::AuthenticationInitiationHelpers
  include Warden::WebAuthn::RegistrationHelpers
  include AdministratorRelyingParty
  include PracticalFramework::Controllers::EmergencyPasskeyRegistrations

  before_action :check_if_self_service_allowed, only: [:new, :create]
  before_action :find_emergency_registration, except: [:new, :create]
  before_action :verify_credential_integrity, only: [:use]
  before_action :verify_passkey_challenge, only: [:use]

  skip_verify_authorized

  layout "administrator"

  def new
    breadcrumb(
      t('.request_form.title.text'),
      new_administrator_emergency_passkey_registration_path
    )

    @form = NewEmergencyPasskeyRegistrationForm.new
  end

  def create
    begin
      Administrator::SendEmergencyPasskeyRegistration.new(
        email: request_form_params[:email],
        ip_address: request.ip,
        user_agent: request.user_agent
      ).run!
    rescue ActiveRecord::RecordNotFound
    end

    set_email_sent_flash
    json_redirect(location: new_administrator_session_url)
  end

  def show
    @form = Administrator::EmergencyPasskeyRegistrationForm.new(emergency_registration: @emergency_registration)
  end

  def use
    begin
      form = Administrator::EmergencyPasskeyRegistrationForm.new(
        emergency_registration: @emergency_registration,
        passkey_label: passkey_params[:passkey_label],
        webauthn_credential: @webauthn_credential
      )

      form.save!

      registered_message = guided_translate('.emergency_passkey_registrations.registered_message')
      flash[:notice] = flash_success_with_icon(message: registered_message)
      json_redirect(location: new_administrator_session_url)
    rescue ActiveRecord::RecordInvalid
      errors = PracticalFramework::FormBuilders::Base.build_error_json(model: form, helpers: helpers)
      render json: errors, status: :bad_request
    end
  end

  protected

  def set_email_sent_flash
    if using_web_awesome?
      icon = helpers.icon_set.sent_email_icon
    else
      icon = helpers.sent_email_icon
    end

    flash[:notice] = flash_notice_with_icon(
      message: guided_translate('.emergency_passkey_registrations.sent_message'),
      icon: icon
    )
  end

  def exclude_external_ids_for_registration
    administrator.passkeys.pluck(:external_id)
  end

  def user_details_for_registration
    { id: administrator.webauthn_id, name: administrator.email }
  end

  def find_emergency_registration
    @emergency_registration = Administrator::EmergencyPasskeyRegistration.find_by_token_for!(:emergency_registration,
                                                                                             params[:id]
                                                                                            )
    @token = params[:id]
  end

  def administrator
    @emergency_registration.administrator
  end

  def passkey_params
    params.require(:administrator_emergency_passkey_registration_form).permit(:passkey_label, :passkey_credential)
  end

  def registration_challenge_key
    "administrator_emergency_passkey_creation_challenge"
  end

  def temporary_form_with_passkey_credential_error(message:)
    temporary_form = Administrator::EmergencyPasskeyRegistrationForm.new
    temporary_form.errors.add(:passkey_credential, message)

    return temporary_form
  end

  def check_if_self_service_allowed
    return if Flipper.enabled?(:self_service_administrator_emergency_passkey_registration)
    head :not_implemented
    return
  end
end
