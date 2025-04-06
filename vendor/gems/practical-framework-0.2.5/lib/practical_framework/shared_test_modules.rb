# frozen_string_literal: true

module PracticalFramework
  module SharedTestModules
    module Controllers
      module Organizations
        module AttachmentsController
        end

        module MembershipInvitationsController
        end

        module MembershipsController
        end
      end

      module Users
        module MembershipInvitationsController
        end

        module MembershipsController
        end
      end

      module EmergencyPasskeyRegistrations
      end

      module Reauthentication
      end

      module Sessions
      end

      module Registrations
      end

      module ResourceUsingDevisePasskeys
      end
    end

    module Forms
      module Organization
        module NewMembershipInvitationForm
        end

        module MembershipForm
        end
      end

      module User
        module MembershipForm
        end
      end

      module CreateNewUserWithMembershipInvitationForm
      end

      module EmergencyPasskeyRegistration
      end
    end

    module Models
      module Attachments
      end

      module EmergencyPasskeyRegistrations
      end

      module Memberships
      end

      module MembershipInvitations
      end

      module Organizations
        module Attachments
        end
      end

      module Utility
        module IPAddresses
        end

        module UserAgents
        end
      end

      module ResourceUsingDevisePasskeys
      end

      module Users
      end

      module Passkeys
      end
    end

    module Policies
      module UserPolicy
      end

      module User
        module PasskeyPolicy
        end

        module MembershipPolicy
        end

        module MembershipInvitationPolicy
        end
      end

      module OrganizationPolicy
      end

      module OrganizationResourcePolicy
      end

      module Organization
        module MembershipPolicy
        end

        module MembershipInvitationPolicy
        end
      end
    end

    module Services
      module SendEmergencyPasskeyRegistration
      end
    end
  end
end

# rubocop:disable Layout/LineLength
require_relative 'shared_test_modules/controllers/emergency_passkey_registrations/base_tests'
require_relative 'shared_test_modules/controllers/emergency_passkey_registrations/cross_pollination_tests'
require_relative 'shared_test_modules/controllers/emergency_passkey_registrations/self_service_tests'
require_relative 'shared_test_modules/controllers/organizations/attachments_controller/base_tests'
require_relative 'shared_test_modules/controllers/organizations/membership_invitations_controller/base_tests'
require_relative 'shared_test_modules/controllers/organizations/memberships_controller/base_tests'
require_relative 'shared_test_modules/controllers/reauthentication/base_tests'
require_relative 'shared_test_modules/controllers/reauthentication/cross_pollination_tests'
require_relative 'shared_test_modules/controllers/registrations/no_self_destroy_tests'
require_relative 'shared_test_modules/controllers/registrations/no_self_signup_tests'
require_relative 'shared_test_modules/controllers/registrations/self_destroy_tests'
require_relative 'shared_test_modules/controllers/registrations/self_signup_tests'
require_relative 'shared_test_modules/controllers/registrations/update_tests'
require_relative 'shared_test_modules/controllers/resource_using_devise_passkeys/base_tests'
require_relative 'shared_test_modules/controllers/sessions/base_tests'
require_relative 'shared_test_modules/controllers/sessions/cross_pollination_tests'
require_relative 'shared_test_modules/controllers/users/membership_invitations_controller/base_tests'
require_relative 'shared_test_modules/controllers/users/memberships_controller/base_tests'
require_relative 'shared_test_modules/forms/create_new_user_with_membership_invitation/base_tests'
require_relative 'shared_test_modules/forms/emergency_passkey_registration/base_tests'
require_relative 'shared_test_modules/forms/organization/membership_form/base_tests'
require_relative 'shared_test_modules/forms/organization/new_membership_invitation_form/base_tests'
require_relative 'shared_test_modules/forms/user/membership_form/base_tests'
require_relative 'shared_test_modules/models/attachments/base_tests'
require_relative 'shared_test_modules/models/attachments/tiptap_document_sgid_tests'
require_relative 'shared_test_modules/models/emergency_passkey_registrations/base_tests'
require_relative 'shared_test_modules/models/emergency_passkey_registrations/use_for_and_notify_tests'
require_relative 'shared_test_modules/models/membership_invitations/base_tests'
require_relative 'shared_test_modules/models/membership_invitations/sending_tests'
require_relative 'shared_test_modules/models/membership_invitations/use_for_and_notify_tests'
require_relative 'shared_test_modules/models/memberships/base_tests'
require_relative 'shared_test_modules/models/normalized_email_tests'
require_relative 'shared_test_modules/models/organizations/attachment_association_tests'
require_relative 'shared_test_modules/models/organizations/attachments/base_tests'
require_relative 'shared_test_modules/models/passkeys/base_tests'
require_relative 'shared_test_modules/models/passkeys/emergency_registration_tests'
require_relative 'shared_test_modules/models/resource_using_devise_passkeys/base_emergency_passkey_registration_tests'
require_relative 'shared_test_modules/models/resource_using_devise_passkeys/base_tests'
require_relative 'shared_test_modules/models/users/base_tests'
require_relative 'shared_test_modules/models/utility/ip_addresses/base_tests'
require_relative 'shared_test_modules/models/utility/user_agents/base_tests'
require_relative 'shared_test_modules/policies/organization/membership_invitation_policy/base_tests'
require_relative 'shared_test_modules/policies/organization/membership_policy/base_tests'
require_relative 'shared_test_modules/policies/organization_policy/base_tests'
require_relative 'shared_test_modules/policies/organization_resource_policy/base_tests'
require_relative 'shared_test_modules/policies/organization_resource_policy/inherits_from_organization_resource_policy_tests'
require_relative 'shared_test_modules/policies/user/membership_invitation_policy/base_tests'
require_relative 'shared_test_modules/policies/user/membership_policy/base_tests'
require_relative 'shared_test_modules/policies/user/passkey_policy/base_tests'
require_relative 'shared_test_modules/policies/user_policy/base_tests'
require_relative 'shared_test_modules/services/send_emergency_passkey_registration/base_tests'
# rubocop:enable Layout/LineLength