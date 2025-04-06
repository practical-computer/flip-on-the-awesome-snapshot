# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class CurrentOrganizationNotLoaded < StandardError; end

  include PracticalFramework::Controllers::FlashHelpers
  include PracticalFramework::Controllers::TranslationHelpers
  include PracticalFramework::Controllers::JSONRedirection
  include PracticalFramework::Controllers::ErrorResponse
  include PatchedFlashHelpers

  before_action :set_webawesome_variant
  before_action :set_honeybadger_context
  before_action :authorize_rack_profile

  layout "main_application"

  helper_method :has_current_organization?,
                :current_organization,
                :inferred_current_organization,
                :honeybadger_context

  verify_authorized

  def has_current_organization?
    @current_organization.present?
  end

  def current_organization
    raise CurrentOrganizationNotLoaded if !has_current_organization?
    return @current_organization
  end

  def inferred_current_organization
    return nil unless user_signed_in?
    return current_organization if has_current_organization?

    available_organizations = authorized_scope(current_user.organizations, with: OrganizationPolicy)

    if available_organizations.size == 1
      return available_organizations.first
    else
      return nil
    end
  end

  def set_honeybadger_context
    Honeybadger.context(honeybadger_context)
  end

  def honeybadger_context
    begin
      user_signed_in?
    rescue NoMethodError
    end

    {
      user_id: current_user&.id,
      user_email: current_user&.email,
      organization_id: @current_organization&.id
    }
  end

  def authorize_rack_profile
    if administrator_signed_in? || Rails.env.development?
      Rack::MiniProfiler.authorize_request
    end
  end

  def using_web_awesome?
    if has_current_organization?
      Flipper.enabled?(:web_awesome, current_organization)
    else
      Flipper.enabled?(:web_awesome, FlipperNoOrganizationActor.instance)
    end
  end

  def set_webawesome_variant
    return unless using_web_awesome?
    request.variant = :webawesome
  end
end
