# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'spy/integration'
require "action_policy/test_helper"
require "practical_framework/test_helpers"
require "practical_framework/shared_test_modules"
require_relative "test_helper/patched_flash_assertions"

if ENV["CIRCLECI"].present?
  require 'minitest/ci'
end

Timecop.safe_mode = true

module WebAwesomeTest
  def self.web_awesome?
    ActiveRecord::Type::Boolean.new.cast(ENV.fetch("WEB_AWESOME"){ false })
  end
end

p(["WEB AWESOME:", ENV["WEB_AWESOME"], WebAwesomeTest.web_awesome?])

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    include PracticalFramework::TestHelpers::TestDebug
    include PracticalFramework::TestHelpers::SimplecovSetup
    include PracticalFramework::TestHelpers::FakerSeedPinning

    include Oaken::TestSetup

    # Add more helper methods to be used by all tests here...
    include PracticalFramework::TestHelpers::SpyHelpers
    include PracticalFramework::TestHelpers::PasskeyAssertionHelpers
    include PracticalFramework::TestHelpers::IntegrationTestAssertions
    include PracticalFramework::TestHelpers::ExtraAssertions

    setup do
      if WebAwesomeTest.web_awesome?
        Flipper.enable(:web_awesome)
      end
    end
  end
end


class ActionDispatch::IntegrationTest
  if WebAwesomeTest.web_awesome?
    include PatchedFlashAssertions
  else
    include PracticalFramework::TestHelpers::FlashAssertions
  end
  include Devise::Test::IntegrationHelpers
  include ActionPolicy::TestHelper
end

class ViewComponentTestCase < ViewComponent::TestCase
end