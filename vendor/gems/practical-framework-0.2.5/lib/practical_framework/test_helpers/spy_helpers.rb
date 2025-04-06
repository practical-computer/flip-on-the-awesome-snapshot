# frozen_string_literal: true

module PracticalFramework::TestHelpers::SpyHelpers
  def assert_times_called(spy:, times:)
    assert_equal times, spy.calls.count
  end
end
