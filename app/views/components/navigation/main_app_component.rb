# frozen_string_literal: true

class Navigation::MainAppComponent < ApplicationComponent
  attr_accessor :current_user, :current_organization

  def initialize(current_user:, current_organization:)
    @current_user = current_user
    @current_organization = current_organization
  end

  def render_organization_switcher?
    return if current_organization.blank?
    return current_user.organizations
                       .excluding(current_organization)
                       .where(memberships: current_user.memberships.active)
                       .any?
  end

  def single_organization?
    return false if render_organization_switcher?
    return current_organization.present?
  end
end
