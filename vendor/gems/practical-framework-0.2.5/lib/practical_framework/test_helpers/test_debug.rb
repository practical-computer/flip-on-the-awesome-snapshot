# frozen_string_literal: true

module PracticalFramework::TestHelpers::TestDebug
  # rubocop:disable Rails/Output
  puts "MINITEST_PARALLEL_EXECUTOR_SIZE: #{Minitest.parallel_executor.size}"
  puts "PARALLEL_WORKERS: #{ENV["PARALLEL_WORKERS"]}"
  # rubocop:enable Rails/Output
end