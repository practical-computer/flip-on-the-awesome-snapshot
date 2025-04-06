# frozen_string_literal: true

require "test_helper"

class Caching::BreakTasksAndOnsitesCacheForOrganizationJobTest < ActiveJob::TestCase
  test "updates the tasks_and_onsites_updated_at for a given job" do
    existing_job = organization_jobs.repeat_customer

    assert_nil existing_job.tasks_and_onsites_updated_at

    Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_now(job: existing_job)

    assert_not_nil existing_job.reload.tasks_and_onsites_updated_at
    old_cache_key = existing_job.tasks_and_onsites_updated_at
    Timecop.freeze(Time.now.utc + 10.hours) do
      Caching::BreakTasksAndOnsitesCacheForOrganizationJob.perform_now(job: existing_job)

      assert_not_equal old_cache_key, existing_job.reload.tasks_and_onsites_updated_at
    end
  end
end
