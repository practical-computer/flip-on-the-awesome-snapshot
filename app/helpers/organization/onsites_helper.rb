# frozen_string_literal: true

module Organization::OnsitesHelper
  def onsite_status_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "draft",
        title: t('dispatcher.onsites.status.draft.human'),
        description: t('dispatcher.onsites.status.draft.description'),
        icon: onsite_status_icon(status: :draft)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "scheduled",
        title: t('dispatcher.onsites.status.scheduled.human'),
        description: t('dispatcher.onsites.status.scheduled.description'),
        icon: onsite_status_icon(status: :scheduled)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "in_progress",
        title: t('dispatcher.onsites.status.in_progress.human'),
        description: t('dispatcher.onsites.status.in_progress.description'),
        icon: onsite_status_icon(status: :in_progress)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "done",
        title: t('dispatcher.onsites.status.done.human'),
        description: t('dispatcher.onsites.status.done.description'),
        icon: onsite_status_icon(status: :done)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "discarded",
        title: t('dispatcher.onsites.status.discarded.human'),
        description: t('dispatcher.onsites.status.discarded.description'),
        icon: onsite_status_icon(status: :discarded)
      ),
    ]
  end

  def human_onsite_status(status:)
    t("dispatcher.onsites.status.#{status}.human")
  end

  def human_onsite_priority(priority:)
    t("dispatcher.onsites.priority.#{priority}.human")
  end

  def onsite_priority_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "regular_priority",
        title: t('dispatcher.onsites.priority.regular_priority.human'),
        description: t('dispatcher.onsites.priority.regular_priority.description'),
        icon: regular_priority_icon
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "high_priority",
        title: t('dispatcher.onsites.priority.high_priority.human'),
        description: t('dispatcher.onsites.priority.high_priority.description'),
        icon: high_priority_icon
      ),
    ]
  end

  def v2_onsite_priority_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "regular_priority",
        title: t('dispatcher.onsites.priority.regular_priority.human'),
        description: t('dispatcher.onsites.priority.regular_priority.description'),
        icon: icon_set.onsite_priority_icon(priority: :regular_priority)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "high_priority",
        title: t('dispatcher.onsites.priority.high_priority.human'),
        description: t('dispatcher.onsites.priority.high_priority.description'),
        icon: icon_set.onsite_priority_icon(priority: :high_priority)
      ),
    ]
  end

  def v2_onsite_status_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "draft",
        title: t('dispatcher.onsites.status.draft.human'),
        description: t('dispatcher.onsites.status.draft.description'),
        icon: icon_set.onsite_status_icon(status: :draft)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "scheduled",
        title: t('dispatcher.onsites.status.scheduled.human'),
        description: t('dispatcher.onsites.status.scheduled.description'),
        icon: icon_set.onsite_status_icon(status: :scheduled)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "in_progress",
        title: t('dispatcher.onsites.status.in_progress.human'),
        description: t('dispatcher.onsites.status.in_progress.description'),
        icon: icon_set.onsite_status_icon(status: :in_progress)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "done",
        title: t('dispatcher.onsites.status.done.human'),
        description: t('dispatcher.onsites.status.done.description'),
        icon: icon_set.onsite_status_icon(status: :done)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "discarded",
        title: t('dispatcher.onsites.status.discarded.human'),
        description: t('dispatcher.onsites.status.discarded.description'),
        icon: icon_set.onsite_status_icon(status: :discarded)
      ),
    ]
  end
end
