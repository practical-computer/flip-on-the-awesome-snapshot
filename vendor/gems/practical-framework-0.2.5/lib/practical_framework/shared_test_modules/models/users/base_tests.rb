# frozen_string_literal: true

module PracticalFramework::SharedTestModules::Models::Users::BaseTests
  extend ActiveSupport::Concern

  included do
    include PracticalFramework::SharedTestModules::Models::NormalizedEmailTests

    test "name: required and cannot be blank" do
      instance = model_instance
      instance.name = ""
      assert_equal false, instance.valid?
      assert_equal true, instance.errors.of_kind?(:name, :blank)

      instance.name = Faker::Name.name
      assert_equal true, instance.valid?
    end
  end
end