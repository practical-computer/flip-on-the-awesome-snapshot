# frozen_string_literal: true

class Organization::JobPolicy < OrganizationResourcePolicy
  default_rule :manage?
  skip_pre_check :same_organization?, only: :create?

  def manage?
    allowed_to?(:show?, organization, with: OrganizationPolicy)
  end

  def create?
    allowed_to?(:show?, organization, with: OrganizationPolicy)
  end

  def manage_onsites?
    result = allowed_to?(:manage)

    if result && record&.archived?
      deny!(:archived_job)
    end

    return result
  end

  alias_method :manage_tasks?, :manage_onsites?

  relation_scope do |relation|
    if !allowed_to?(:show?, organization, with: OrganizationPolicy)
      next relation.none
    end

    relation.where(organization: organization)
  end
end