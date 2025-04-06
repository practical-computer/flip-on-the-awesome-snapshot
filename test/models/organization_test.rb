# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  include PracticalFramework::SharedTestModules::Models::Organizations::AttachmentAssociationTests

  def model_class
    Organization
  end

  test "has_many :jobs" do
    reflection = Organization.reflect_on_association(:jobs)
    assert_equal :has_many, reflection.macro
  end

  test "has_many :onsites, through: :jobs" do
    reflection = Organization.reflect_on_association(:onsites)
    assert_equal :jobs, reflection.options[:through]
    assert_equal :has_many, reflection.macro
  end
end
