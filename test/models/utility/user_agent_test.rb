# frozen_string_literal: true

require "test_helper"

class Utility::UserAgentTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Utility::UserAgents::BaseTests

  def model_class
    Utility::UserAgent
  end

  def new_model_instance(user_agent: Faker::Computer.stack)
    Utility::UserAgent.new(user_agent: user_agent)
  end
end
