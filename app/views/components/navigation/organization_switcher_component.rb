# frozen_string_literal: true

class Navigation::OrganizationSwitcherComponent < ApplicationComponent
  attr_accessor :current_user, :current_organization

  def initialize(current_user:, current_organization:)
    @current_user = current_user
    @current_organization = current_organization
  end

  def active_memberships
    @active_memberships ||= current_user.memberships.active
  end

  def ordered_other_organizations
    @ordered_organizations ||= (
      current_user.organizations
                  .excluding(current_organization)
                  .order(name: :asc)
                  .where(memberships: active_memberships)
    )
  end
end
