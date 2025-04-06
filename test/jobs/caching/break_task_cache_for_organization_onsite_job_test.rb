# frozen_string_literal: true

require "test_helper"

class Caching::BreakTaskCacheForOrganizationOnsiteJobTest < ActiveJob::TestCase
  test "updates the tasks_updated_at for a given onsite" do
    existing_onsite = organization_onsites.repeat_onsite_1

    assert_nil existing_onsite.tasks_updated_at

    Caching::BreakTaskCacheForOrganizationOnsiteJob.perform_now(onsite: existing_onsite)

    assert_not_nil existing_onsite.reload.tasks_updated_at
    old_cache_key = existing_onsite.tasks_updated_at
    Timecop.freeze(Time.now.utc + 10.hours) do
      Caching::BreakTaskCacheForOrganizationOnsiteJob.perform_now(onsite: existing_onsite)

      assert_not_equal old_cache_key, existing_onsite.reload.tasks_updated_at
    end
  end
end
