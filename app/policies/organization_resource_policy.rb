# frozen_string_literal: true

class OrganizationResourcePolicy < ApplicationPolicy
  pre_check :same_organization?

  authorize :organization

  protected

  def same_organization?
    return if record.organization == organization
    deny!
  end
end