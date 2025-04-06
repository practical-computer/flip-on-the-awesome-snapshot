# frozen_string_literal: true

class Organization::UserPolicy < OrganizationResourcePolicy
  relation_scope do |relation|
    if !allowed_to?(:show?, record, with: OrganizationPolicy)
      next relation.none
    end

    record.users
          .where(memberships: record.memberships.active)
          .and(relation)
  end
end