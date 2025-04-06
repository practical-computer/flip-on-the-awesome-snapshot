# frozen_string_literal: true

require "application_system_test_case"

class Readonly::OnsitesTest < ApplicationSystemTestCase
  test "can visit from the token" do
    self.default_url_options[:host] = AppSettings.default_host

    onsite = organization_onsites.repeat_onsite_1

    token = onsite.generate_token_for(:readonly_view)

    visit readonly_onsite_url(token)
    assert_selector "h1", text: "Dispatcher"

    if WebAwesomeTest.web_awesome?
      assert_selector "h2", text: onsite.label
      assert_selector ".wa-callout", text: onsite.job.name

      assert_selector "h3", text: I18n.translate('dispatcher.job_tasks.categories.onsite_tasks.title')
    else
      assert_selector "h1", text: onsite.job.name
      assert_selector "h2", text: onsite.label

      assert_selector "h2", text: I18n.translate('dispatcher.job_tasks.categories.onsite_tasks.title')
    end
  end
end
