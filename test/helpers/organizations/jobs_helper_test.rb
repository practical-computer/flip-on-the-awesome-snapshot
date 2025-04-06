# frozen_string_literal: true

require "test_helper"

class Organizations::JobsHelperTest < ActionView::TestCase
  include IconHelper
  include FontAwesomeHelpers::ViewHelpers

  test "job_status_options" do
    expected = [
      PracticalFramework::Forms::CollectionOption.new(
        value: "active",
        title: t('dispatcher.jobs.status.active.human'),
        description: t('dispatcher.jobs.status.active.description'),
        icon: job_status_icon(status: :active)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "archived",
        title: t('dispatcher.jobs.status.archived.human'),
        description: t('dispatcher.jobs.status.archived.description'),
        icon: job_status_icon(status: :archived)
      ),
    ]

    assert_equal expected, job_status_options
  end
end