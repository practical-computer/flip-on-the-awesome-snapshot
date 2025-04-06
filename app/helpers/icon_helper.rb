# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

module IconHelper
  def warehouse_icon
    icon(style: "fa-duotone fa-fw", name: "warehouse")
  end

  def badge_icon
    icon(style: 'fa-duotone fa-fw', name: "id-badge")
  end

  def job_icon
    cached_icon(symbol_name: 'job', style: 'fa-duotone fa-fw', name: 'house-building')
  end

  def add_job_icon
    icon(style: 'fa-kit fa-fw', name: "solid-house-building-circle-plus")
  end

  def edit_job_icon
    icon(style: 'fa-kit fa-fw', name: "solid-house-building-pen")
  end

  def job_name_icon
    cached_icon(symbol_name: 'job_name', style: 'fa-duotone fa-fw', name: 'handshake')
  end

  def active_icon
    cached_icon(symbol_name: 'active', style: 'fa-duotone fa-fw', name: 'box-open')
  end

  def archive_icon
    cached_icon(symbol_name: 'archive', style: 'fa-duotone fa-fw', name: 'box-taped')
  end

  def status_icon
    cached_icon(symbol_name: 'status', style: 'fa-duotone fa-fw', name: 'square-question')
  end

  def location_icon
    cached_icon(symbol_name: 'location', style: 'fa-duotone fa-fw', name: 'map-location-dot')
  end

  def priority_icon
    cached_icon(symbol_name: 'priority', style: 'fa-kit fa-fw', name: "solid-diamond-circle-question")
  end

  def regular_priority_icon
    cached_icon(symbol_name: 'regular-priority', style: 'fa-duotone fa-fw', name: "diamond")
  end

  def high_priority_icon
    cached_icon(symbol_name: 'high-priority', style: 'fa-duotone fa-fw', name: "diamond-exclamation")
  end

  def onsite_icon
    cached_icon(symbol_name: 'onsite', style: 'fa-solid fa-fw', name: "truck-pickup")
  end

  def add_onsite_icon
    icon(style: 'fa-kit fa-fw', name: "solid-truck-pickup-circle-plus")
  end

  def edit_onsite_icon
    icon(style: 'fa-kit fa-fw', name: "solid-truck-pickup-pen")
  end

  def onsite_label_icon
    cached_icon(symbol_name: 'onsite-label', style: 'fa-solid fa-fw', name: "tag")
  end

  def onsite_draft_icon
    cached_icon(symbol_name: 'onsite-draft', style: 'fa-duotone fa-fw', name: "compass-drafting")
  end

  def onsite_scheduled_icon
    cached_icon(symbol_name: 'onsite-scheduled', style: 'fa-solid fa-fw', name: "calendar-day")
  end

  def onsite_in_progress_icon
    cached_icon(symbol_name: 'onsite-in-progress', style: 'fa-solid fa-fw', name: "bolt")
  end

  def onsite_done_icon
    cached_icon(symbol_name: "onsite-done", style: 'fa-duotone fa-fw', name: "party-horn")
  end

  def onsite_discarded_icon
    cached_icon(symbol_name: "onsite-discarded", style: 'fa-duotone fa-fw', name: "trash")
  end

  def add_job_task_icon
    icon(style: 'fa-kit fa-fw', name: "solid-clipboard-list-check-circle-plus")
  end

  def edit_job_task_icon
    icon(style: 'fa-kit fa-fw', name: "solid-clipboard-list-check-pen")
  end

  def job_task_icon
    icon(style: 'fa-duotone fa-fw', name: "clipboard-list-check")
  end

  def job_task_label_icon
    icon(style: 'fa-solid fa-fw', name: "scribble")
  end

  def todo_icon
    icon(style: 'fa-regular fa-fw', name: "circle")
  end

  def done_icon
    icon(style: 'fa-duotone fa-fw', name: "circle-check")
  end

  def cancelled_icon
    icon(style: 'fa-duotone fa-fw', name: "circle-xmark")
  end

  def job_task_type_label_icon
    icon(style: 'fa-duotone fa-fw', name: "bucket")
  end

  def estimated_duration_icon
    icon(style: 'fa-duotone fa-fw', name: "face-thinking")
  end

  def membership_type_icon(membership_type:)
    case membership_type.to_sym
    when :staff
      badge_icon
    when :organization_manager
      icon(style: 'fa-duotone fa-fw', name: 'users-gear')
    end
  end

  def job_status_icon(status:)
    case status.to_sym
    when :active
      active_icon
    when :archived
      archive_icon
    end
  end

  def onsite_status_icon(status:)
    case status.to_sym
    when :draft
      onsite_draft_icon
    when :scheduled
      onsite_scheduled_icon
    when :in_progress
      onsite_in_progress_icon
    when :done
      onsite_done_icon
    when :discarded
      onsite_discarded_icon
    end
  end

  def onsite_priority_icon(priority:)
    case priority.to_sym
    when :regular_priority
      regular_priority_icon
    when :high_priority
      high_priority_icon
    end
  end

  def job_task_status_icon(status:)
    case status.to_sym
    when :todo
      todo_icon
    when :done
      done_icon
    when :cancelled
      cancelled_icon
    end
  end

  def job_task_type_icon(task_type:)
    case task_type.to_sym
    when :onsite
      onsite_icon
    when :offsite
      warehouse_icon
    end
  end

  def app_icon
    File.read(Rails.root.join("app/assets/images/icons/icon.svg")).html_safe
  end
end

# rubocop:enable Metrics/ModuleLength