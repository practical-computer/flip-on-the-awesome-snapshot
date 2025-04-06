# frozen_string_literal: true

require "test_helper"

class Organization::NewMembershipInvitationFormTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Forms::Organization::NewMembershipInvitationForm::BaseTests
end