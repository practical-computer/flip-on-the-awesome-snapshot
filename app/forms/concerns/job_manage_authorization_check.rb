# frozen_string_literal: true

module JobManageAuthorizationCheck
  extend ActiveSupport::Concern

  def job_can_manage?(policy_action:, cannot_manage_error_key:)
    policy_check = allowance_to(policy_action, job, with: Organization::JobPolicy)
    return if policy_check.value

    if policy_check.reasons.details.dig(:"organization/job")&.include?(:archived_job)
      errors.add(:base, :archived_job)
    else
      errors.add(:base, cannot_manage_error_key)
    end
  end
end