# frozen_string_literal: true

require "test_helper"

class CreateNewUserWithMembershipInvitationFormTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include PracticalFramework::SharedTestModules::Forms::CreateNewUserWithMembershipInvitationForm::BaseTests
end