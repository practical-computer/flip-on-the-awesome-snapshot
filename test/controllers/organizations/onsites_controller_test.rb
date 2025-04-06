# frozen_string_literal: true

require "test_helper"

class Organization::OnsitesControllerTest < ActionDispatch::IntegrationTest
  def assert_index_policies_applied(organization:, &block)
    assert_have_authorized_scope(type: :active_record_relation, with: Organization::OnsitePolicy, &block)
  end

  def assert_job_manage_onsite_policies_applied(organization:, user:, target_job:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage_onsites?, target_job, with: Organization::JobPolicy, &block)
    end
  end

  def assert_manage_onsite_policies_applied(organization:, user:, onsite:, &block)
    assert_authorized_to(:show?, organization, with: OrganizationPolicy) do
      assert_authorized_to(:manage?, onsite, with: Organization::OnsitePolicy, &block)
    end
  end

  def assert_flash_success(message:)
    if WebAwesomeTest.web_awesome?
      assert_flash_message(type: :success, message: message, icon_name: "truck-pickup")
    else
      assert_flash_message(type: :success, message: message, icon_name: "#onsite")
    end
  end

  test "new: renders the form for a new onsite for a job" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    assert_job_manage_onsite_policies_applied(organization: organization, user: user, target_job: organization_job) do
      get new_organization_job_onsite_url(organization, organization_job)
    end

    assert_response :ok
  end

  test "create: creates a new onsite for a job" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = Faker::Team.name

    params = {
      organization_onsite: {
        label: label,
        priority: :regular_priority,
        status: :draft
      }
    }

    assert_job_manage_onsite_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::Onsite.count", +1 do
      post organization_job_onsites_url(organization, organization_job), params: params, as: :json
    end
    end
    end

    new_onsite = organization.onsites.last

    message = I18n.t("dispatcher.onsites.created_message")
    assert_flash_success(message: message)

    assert_equal organization, new_onsite.organization
    assert_equal organization_job, new_onsite.job
    assert_equal label, new_onsite.label
    assert_equal true, new_onsite.regular_priority?
    assert_equal true, new_onsite.draft?
  end

  test "create: creates a new onsite with a google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = Faker::Team.name

    google_place_json = {place_id: SecureRandom.hex, formatted_address: Faker::Address.full_address}

    params = {
      organization_onsite: {
        label: label,
        priority: :regular_priority,
        status: :draft,
        google_place: google_place_json.to_json
      }
    }

    assert_job_manage_onsite_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_difference "Organization::Onsite.count", +1 do
    assert_difference "GooglePlace.count", +1 do
      post organization_job_onsites_url(organization, organization_job), params: params, as: :json
    end
    end
    end
    end

    new_onsite = organization.onsites.last

    message = I18n.t("dispatcher.onsites.created_message")
    assert_flash_success(message: message)

    assert_equal organization, new_onsite.organization
    assert_equal organization_job, new_onsite.job
    assert_equal label, new_onsite.label
    assert_equal true, new_onsite.regular_priority?
    assert_equal true, new_onsite.draft?
    assert_equal google_place_json[:place_id], new_onsite.google_place.google_place_api_id
    assert_equal google_place_json[:formatted_address], new_onsite.google_place.human_address
  end

  test "create: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = " "

    params = {
      organization_onsite: {
        label: label,
        priority: :regular_priority,
        status: :draft
      }
    }

    assert_job_manage_onsite_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Onsite.count" do
      post organization_job_onsites_url(organization, organization_job), params: params, as: :json
    end
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_onsite_label_errors",
      element_id: "organization_onsite_label",
      message: "can't be blank",
    )
  end

  test "create: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    label = " "

    params = {
      organization_onsite: {
        label: label,
        priority: :regular_priority,
        status: :draft
      }
    }

    assert_job_manage_onsite_policies_applied(organization: organization, user: user, target_job: organization_job) do
    assert_no_difference "Organization::Job.count" do
    assert_no_difference "Organization::Onsite.count" do
      post organization_job_onsites_url(organization, organization_job), params: params
    end
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_onsite_label_errors",
      message: "can't be blank",
    )
  end

  test "show: renders an existing onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
      get onsite_url(organization, onsite)
    end

    assert_response :ok
    if WebAwesomeTest.web_awesome?
      assert_dom "h2", text: onsite.label
    else
      assert_dom "h1", text: onsite.label
    end
  end

  test "show: renders an existing job with a google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first
    assert_not_nil onsite.google_place
    address = onsite.google_place.human_address

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
      get onsite_url(organization, onsite)
    end

    assert_response :ok
    assert_dom 'address.google-place', address
  end

  test "edit: renders the edit form for an onsite" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
      get edit_onsite_url(organization, onsite)
    end

    assert_response :ok
  end

  test "update: updates the existing onsite with a new label" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    new_label = Faker::Team.name

    params = {
      organization_onsite: {
        label: new_label
      }
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params, as: :json
    end
    end

    onsite.reload
    assert_json_redirected_to(onsite_url(organization, onsite))

    message = I18n.t('dispatcher.onsites.updated_message', onsite_label: new_label, job_name: onsite.job.name)
    assert_flash_success(message: message)

    assert_equal new_label, onsite.label
  end

  test "update: updates the existing onsite with a new status" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    new_status = :in_progress

    params = {
      organization_onsite: {
        status: new_status
      }
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params, as: :json
    end
    end

    onsite.reload
    assert_json_redirected_to(onsite_url(organization, onsite))

    message = I18n.t('dispatcher.onsites.updated_message', onsite_label: onsite.label, job_name: onsite.job.name)
    assert_flash_success(message: message)

    assert_equal new_status.to_s, onsite.status
  end

  test "update: updates the existing onsite with a new google_place" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    google_place_api_id = SecureRandom.hex
    address = Faker::Address.full_address

    google_place_data = { place_id: google_place_api_id, formatted_address: address }

    params = {
      organization_onsite: {google_place: google_place_data.to_json}
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params, as: :json
    end
    end

    onsite.reload
    assert_json_redirected_to(onsite_url(organization, onsite))

    message = I18n.t('dispatcher.onsites.updated_message', onsite_label: onsite.label, job_name: onsite.job.name)
    assert_flash_success(message: message)

    assert_equal google_place_api_id, onsite.google_place.google_place_api_id
    assert_equal address, onsite.google_place.human_address
  end

  test "update: updates the existing onsite with a new priority" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    new_priority = :high_priority

    params = {
      organization_onsite: {
        priority: new_priority
      }
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params, as: :json
    end
    end

    onsite.reload
    assert_json_redirected_to(onsite_url(organization, onsite))

    message = I18n.t('dispatcher.onsites.updated_message', onsite_label: onsite.label, job_name: onsite.job.name)
    assert_flash_success(message: message)

    assert_equal new_priority.to_s, onsite.priority
  end

  test "update: renders errors as JSON" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    new_label = "   "

    params = {
      organization_onsite: {
        label: new_label
      }
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params, as: :json
    end
    end

    assert_response :bad_request

    assert_error_json_contains(
      container_id: "organization_onsite_label_errors",
      element_id: "organization_onsite_label",
      message: "can't be blank",
    )
  end

  test "update: renders errors as HTML" do
    user = users.moonlighter
    organization = organizations.organization_1
    organization_job = organization_jobs.repeat_customer
    sign_in(user)

    onsite = organization_job.onsites.first

    new_label = "   "

    params = {
      organization_onsite: {
        label: new_label
      }
    }

    assert_manage_onsite_policies_applied(organization: organization, user: user, onsite: onsite) do
    assert_no_difference "Organization::Onsite.count" do
      patch onsite_url(organization, onsite), params: params
    end
    end

    assert_response :bad_request

    assert_error_dom(
      container_id: "organization_onsite_label_errors",
      message: "can't be blank",
    )
  end
end
