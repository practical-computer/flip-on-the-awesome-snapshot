# frozen_string_literal: true

class Caching::BreakTaskCacheForOrganizationOnsiteJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :caching

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { "#{self.class.name}-#{arguments.last[:onsite].id}"}
  )

  def perform(onsite:)
    onsite.update_columns(tasks_updated_at: Time.now.utc)
  end
end
