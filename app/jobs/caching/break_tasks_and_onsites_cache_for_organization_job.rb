# frozen_string_literal: true

class Caching::BreakTasksAndOnsitesCacheForOrganizationJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :caching

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { "#{self.class.name}-#{arguments.last[:job].id}"}
  )

  def perform(job:)
    job.update_columns(tasks_and_onsites_updated_at: Time.now.utc)
  end
end
