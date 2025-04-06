# frozen_string_literal: true

module Organizations::JobTasksHelper
  def job_task_status_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "todo",
        title: t('dispatcher.job_tasks.status.todo.human'),
        description: t('dispatcher.job_tasks.status.todo.description'),
        icon: job_task_status_icon(status: :todo)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "done",
        title: t('dispatcher.job_tasks.status.done.human'),
        description: t('dispatcher.job_tasks.status.done.description'),
        icon: job_task_status_icon(status: :done)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "cancelled",
        title: t('dispatcher.job_tasks.status.cancelled.human'),
        description: t('dispatcher.job_tasks.status.cancelled.description'),
        icon: job_task_status_icon(status: :cancelled)
      ),
    ]
  end

  def job_task_type_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "onsite",
        title: t('dispatcher.job_tasks.task_type.onsite.human'),
        description: t('dispatcher.job_tasks.task_type.onsite.description'),
        icon: job_task_type_icon(task_type: :onsite)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "offsite",
        title: t('dispatcher.job_tasks.task_type.offsite.human'),
        description: t('dispatcher.job_tasks.task_type.offsite.description'),
        icon: job_task_type_icon(task_type: :offsite)
      ),
    ]
  end

  def v2_job_task_status_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "todo",
        title: t('dispatcher.job_tasks.status.todo.human'),
        description: t('dispatcher.job_tasks.status.todo.description'),
        icon: icon_set.job_task_status_icon(status: :todo)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "done",
        title: t('dispatcher.job_tasks.status.done.human'),
        description: t('dispatcher.job_tasks.status.done.description'),
        icon: icon_set.job_task_status_icon(status: :done)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "cancelled",
        title: t('dispatcher.job_tasks.status.cancelled.human'),
        description: t('dispatcher.job_tasks.status.cancelled.description'),
        icon: icon_set.job_task_status_icon(status: :cancelled)
      ),
    ]
  end

  def v2_job_task_type_options
    [
      PracticalFramework::Forms::CollectionOption.new(
        value: "onsite",
        title: t('dispatcher.job_tasks.task_type.onsite.human'),
        description: t('dispatcher.job_tasks.task_type.onsite.description'),
        icon: icon_set.job_task_type_icon(task_type: :onsite)
      ),
      PracticalFramework::Forms::CollectionOption.new(
        value: "offsite",
        title: t('dispatcher.job_tasks.task_type.offsite.human'),
        description: t('dispatcher.job_tasks.task_type.offsite.description'),
        icon: icon_set.job_task_type_icon(task_type: :offsite)
      ),
    ]
  end

  def human_job_task_status(status:)
    t("dispatcher.job_tasks.status.#{status}.human")
  end

  def onsite_options(onsites:, selected_onsite:)
    result_html = []
    result_html << options_for_select([["No onsite", nil]], selected_onsite&.id)
    result_html << content_tag(:hr)
    result_html << options_for_select((onsites.map do |x|
      [x.label, x.id]
    end), selected_onsite&.id)

    return safe_join(result_html, "")
  end

  def job_task_assigned_url(job_task:)
    if job_task.onsite.present?
      return onsite_url(job_task.organization, job_task.onsite)
    end

    return organization_job_url(job_task.organization, job_task.job)
  end

  def human_minutes(minutes:)
    minutes = minutes.to_i
    hours = minutes / 60
    remaining_minutes = minutes % 60

    [hours, remaining_minutes.to_s.rjust(2, "0")].join(":")
  end

  def job_task_onsite_label(job_task:, short_no_onsite_message: false)
    if job_task.onsite.blank?
      if short_no_onsite_message
        message = t("dispatcher.job_tasks.no_onsite.short")
      else
        message = t("dispatcher.job_tasks.no_onsite.human")
      end
      content_tag(:em, message)
    else
      link_to job_task.onsite.label, onsite_url(current_organization, job_task.onsite)
    end
  end
end
