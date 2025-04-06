# frozen_string_literal: true

module Organizations::JobsHelper
  def job_status_options
    [
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
  end

  def v2_job_status_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "active",
        title: t('dispatcher.jobs.status.active.human'),
        description: t('dispatcher.jobs.status.active.description'),
        icon: icon_set.job_status_icon(status: :active)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "archived",
        title: t('dispatcher.jobs.status.archived.human'),
        description: t('dispatcher.jobs.status.archived.description'),
        icon: icon_set.job_status_icon(status: :archived)
      ),
    ]
  end

  def human_job_status(status:)
    t("dispatcher.jobs.status.#{status}.human")
  end
end
