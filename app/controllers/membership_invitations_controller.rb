# frozen_string_literal: true

class MembershipInvitationsController < ApplicationController
  include Warden::WebAuthn::AuthenticationInitiationHelpers
  include Warden::WebAuthn::RegistrationHelpers
  include RelyingParty
  include PracticalFramework::Controllers::CreateUserFromInvitations

  before_action :find_membership_invitation
  before_action :verify_credential_integrity, only: [:create_user_and_use]
  before_action :verify_passkey_challenge, only: [:create_user_and_use]
  before_action :authenticate_user!, only: [:accept_as_current_user]

  skip_verify_authorized

  breadcrumb :membership_invitation, :membership_invitation_path

  layout "app_chrome"

  def show
    store_location_for(:user, membership_invitation_path(params[:id]))

    if !user_signed_in?
      @new_user_form = CreateNewUserWithMembershipInvitationForm.new(user: User.new,
                                                                     membership_invitation: @membership_invitation,
                                                                     email: @membership_invitation.email,
                                                                    )
    end
  end

  def create_user_and_use
    form_params = user_from_invitation_form_params.merge(user: User.new(webauthn_id: registration_user_id),
                                                         membership_invitation: @membership_invitation,
                                                         webauthn_credential: @webauthn_credential
                                                        )
    form = CreateNewUserWithMembershipInvitationForm.new(form_params)
    form.save!

    flash[:notice] = flash_success_with_icon(message: t('membership_invitations.registered_message'))
    json_redirect(location: new_user_session_url)
    store_location_for(:user, organization_url(@membership_invitation.organization))
  rescue ActiveRecord::RecordInvalid
    errors = PracticalFramework::FormBuilders::Base.build_error_json(model: form, helpers: helpers)
    render json: errors, status: :bad_request
  end

  def accept_as_current_user
    @membership_invitation.use_for_and_notify!(user: current_user)
    set_accept_as_current_user_flash
    redirect_to organization_url(@membership_invitation.organization)
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.errors.of_kind?(:user, :taken)
    flash[:alert] = flash_alert_with_icon(message: e.record.errors[:user].join)
    render :show, status: :unprocessable_entity
  end

  def sign_out_then_show
    sign_out(:user)
    redirect_to membership_invitation_url(params[:id])
  end

  protected

  def set_accept_as_current_user_flash
    if using_web_awesome?
      icon = helpers.icon_set.accepted_membership_invitation_icon
    else
      icon = helpers.icon(style: "fa-kit", name: 'solid-warehouse-circle-check')
    end

    message = t('membership_invitations.accepted_message', organization_name: @membership_invitation.organization.name)
    flash[:success] = flash_success_with_icon(message: message, icon: icon)
  end

  def find_membership_invitation
    @membership_invitation = MembershipInvitation.unused.visible.find_by_token_for!(:invitation, params[:id])
  end

  def registration_challenge_key
    "user_from_invitation_creation_challenge"
  end

  def registration_user_id_key
    "user_from_invitation_webauthn_id"
  end

  def user_details_for_registration
    store_registration_user_id
    { id: registration_user_id, name: user_details_params[:email], display_name: user_details_params[:name] }
  end

  def user_details_params
    params.require(:create_new_user_with_membership_invitation_form).permit(:email, :name)
  end

  def user_from_invitation_form_params
    params.require(:create_new_user_with_membership_invitation_form).permit(:email, :name, :passkey_label)
  end

  def passkey_params
    params.require(:create_new_user_with_membership_invitation_form).permit(:passkey_label, :passkey_credential)
  end

  def temporary_form_with_passkey_credential_error(message:)
    temporary_form = CreateNewUserWithMembershipInvitationForm.new
    temporary_form.errors.add(:passkey_credential, message)

    return temporary_form
  end
end
