# frozen_string_literal: true

class Organization::JobTaskPolicy < Organization::JobPolicy
  relation_scope do |relation|
    if !allowed_to?(:show?, organization, with: OrganizationPolicy)
      next relation.none
    end

    relation.joins(:organization)
            .where(organization_jobs: { organization_id: organization })
  end
end