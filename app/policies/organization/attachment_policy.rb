# frozen_string_literal: true

class Organization::AttachmentPolicy < OrganizationResourcePolicy
  default_rule :create?
  skip_pre_check :same_organization?, only: :create?

  def create?
    allowed_to?(:show?, organization, with: OrganizationPolicy)
  end

  relation_scope do |relation|
    if !allowed_to?(:show?, organization, with: OrganizationPolicy)
      next relation.none
    end

    relation.where(organization: organization)
  end
end