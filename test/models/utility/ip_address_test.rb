# frozen_string_literal: true

require "test_helper"

class Utility::IPAddressTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Utility::IPAddresses::BaseTests

  def model_class
    Utility::IPAddress
  end

  def new_model_instance(address: Faker::Internet.ip_v6_address)
    Utility::IPAddress.new(address: address)
  end
end
