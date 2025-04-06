# frozen_string_literal: true

require "test_helper"

class Readonly::OnsitesControllerTest < ActionDispatch::IntegrationTest
  test "show: gets the onsite by its readonly token" do
    onsite = organization_onsites.repeat_onsite_1

    token = onsite.generate_token_for(:readonly_view)

    get readonly_onsite_url(token)

    assert_response :ok

    if WebAwesomeTest.web_awesome?
      assert_dom "h2", text: onsite.label
      assert_dom ".wa-callout", %r{#{onsite.job.name}}
    else
      assert_dom "h1", onsite.job.name
      assert_dom "h2", onsite.label
    end
  end

  test "show: does not get an onsite by its ID" do
    onsite = organization_onsites.repeat_onsite_1
    get readonly_onsite_url(onsite.id)
    assert_response :not_found
  end

  test "show: does not get an onsite by an old token" do
    onsite = organization_onsites.repeat_onsite_1
    old_token = onsite.generate_token_for(:readonly_view)
    onsite.update!(readonly_token_generated_at: Time.now.utc)

    get readonly_onsite_url(old_token)
    assert_response :not_found
  end
end
