# frozen_string_literal: true

class Users::EmergencyPasskeyRegistrationsController < DeviseController
  include Warden::WebAuthn::AuthenticationInitiationHelpers
  include Warden::WebAuthn::RegistrationHelpers
  include RelyingParty
  include PracticalFramework::Controllers::EmergencyPasskeyRegistrations

  before_action :find_emergency_registration, except: [:new, :create]
  before_action :verify_credential_integrity, only: [:use]
  before_action :verify_passkey_challenge, only: [:use]

  skip_verify_authorized

  layout "app_chrome"

  def new
    breadcrumb(
      t('.request_form.title.text'),
      new_user_emergency_passkey_registration_path
    )

    @form = NewEmergencyPasskeyRegistrationForm.new
  end

  def create
    begin
      User::SendEmergencyPasskeyRegistration.new(
        email: request_form_params[:email],
        ip_address: request.ip,
        user_agent: request.user_agent
      ).run!
    rescue ActiveRecord::RecordNotFound
    end

    set_email_sent_flash
    json_redirect(location: new_user_session_url)
  end

  def show
    @form = User::EmergencyPasskeyRegistrationForm.new(emergency_registration: @emergency_registration)
  end

  def use
    begin
      form = User::EmergencyPasskeyRegistrationForm.new(
        emergency_registration: @emergency_registration,
        passkey_label: passkey_params[:passkey_label],
        webauthn_credential: @webauthn_credential
      )

      form.save!

      registered_message = guided_translate('.emergency_passkey_registrations.registered_message')
      flash[:notice] = flash_success_with_icon(message: registered_message)
      json_redirect(location: new_user_session_url)
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
    user.passkeys.pluck(:external_id)
  end

  def user_details_for_registration
    { id: user.webauthn_id, name: user.email, display_name: user.name }
  end

  def find_emergency_registration
    @emergency_registration = User::EmergencyPasskeyRegistration.find_by_token_for!(:emergency_registration,
                                                                                    params[:id]
                                                                                  )
    @token = params[:id]
  end

  def user
    @emergency_registration.user
  end

  def passkey_params
    params.require(:user_emergency_passkey_registration_form).permit(:passkey_label, :passkey_credential)
  end

  def registration_challenge_key
    "user_emergency_passkey_creation_challenge"
  end

  def temporary_form_with_passkey_credential_error(message:)
    temporary_form = User::EmergencyPasskeyRegistrationForm.new
    temporary_form.errors.add(:passkey_credential, message)

    return temporary_form
  end
end
