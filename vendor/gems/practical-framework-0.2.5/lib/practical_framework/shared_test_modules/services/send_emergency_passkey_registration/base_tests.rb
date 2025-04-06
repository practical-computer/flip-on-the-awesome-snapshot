# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Services::SendEmergencyPasskeyRegistration::BaseTests
  extend ActiveSupport::Concern

  included do
    test "raises ActiveRecord::RecordNotFound if no user with this email address" do
      assert_raises ActiveRecord::RecordNotFound do
        service_class.new(
          email: "bad@example.com",
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent,
        ).run!
      end
    end

    test "does not break if no ip_address given" do
      assert_successful_run(service: service_class.new(
        email: valid_email,
        ip_address: "   ",
        user_agent: Faker::Internet.user_agent,
      ))
    end

    test "does not break if no user_agent given" do
      assert_successful_run(service: service_class.new(
        email: valid_email,
        ip_address: Faker::Internet.ip_v4_address,
        user_agent: "   ",
      ))
    end

    test "returns true if the email was sent" do
      assert_successful_run(service: service_class.new(
        email: valid_email,
        ip_address: Faker::Internet.ip_v4_address,
        user_agent: Faker::Internet.user_agent,
      ))
    end

    test "raises any unexpected errors" do
      spy = Spy.on(mailer_class, :emergency_registration_request).and_raise(ArgumentError)

      assert_raises ArgumentError do
        service_class.new(
          email: valid_email,
          ip_address: Faker::Internet.ip_v4_address,
          user_agent: Faker::Internet.user_agent,
        ).run!
      end
    end
  end
end