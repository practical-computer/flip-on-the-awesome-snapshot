# frozen_string_literal: true

class ApplicationIconSet < PracticalViews::IconSet
  define_icons(icon_definitions: [
    IconDefinition.new(method_name: :job_icon, icon_name: :"house-building", preset: :duotone),
    IconDefinition.new(method_name: :add_job_icon, icon_name: :"solid-house-building-circle-plus", preset: :kit),
    IconDefinition.new(method_name: :edit_job_icon, icon_name: :"solid-house-building-pen", preset: :kit),

    IconDefinition.new(method_name: :job_name_icon, icon_name: :handshake, preset: :duotone),
    IconDefinition.new(method_name: :active_icon, icon_name: :"box-open", preset: :duotone),
    IconDefinition.new(method_name: :archived_icon, icon_name: :"box-taped", preset: :duotone),
    IconDefinition.new(method_name: :status_icon, icon_name: :"square-question", preset: :duotone),

    IconDefinition.new(method_name: :location_icon, icon_name: :"map-location-dot", preset: :duotone),

    IconDefinition.new(method_name: :priority_icon, icon_name: :"solid-diamond-circle-question", preset: :kit),
    IconDefinition.new(method_name: :regular_priority_icon, icon_name: :diamond, preset: :duotone),
    IconDefinition.new(method_name: :high_priority_icon, icon_name: :"diamond-exclamation", preset: :duotone),

    IconDefinition.new(method_name: :onsite_icon, icon_name: :"truck-pickup", preset: :duotone),
    IconDefinition.new(method_name: :add_onsite_icon, icon_name: :"solid-truck-pickup-pen", preset: :kit),
    IconDefinition.new(method_name: :onsite_label_icon, icon_name: :tag, preset: :solid),

    IconDefinition.new(method_name: :onsite_draft_icon, icon_name: :"compass-drafting", preset: :duotone),
    IconDefinition.new(method_name: :onsite_scheduled_icon, icon_name: :"calendar-day", preset: :solid),
    IconDefinition.new(method_name: :onsite_in_progress_icon, icon_name: :bolt, preset: :solid),
    IconDefinition.new(method_name: :onsite_discarded_icon, icon_name: :trash, preset: :duotone),
    IconDefinition.new(method_name: :onsite_done_icon, icon_name: :"party-horn", preset: :duotone),

    IconDefinition.new(method_name: :job_task_icon, icon_name: :"clipboard-list-check", preset: :duotone),
    IconDefinition.new(method_name: :add_job_task_icon, icon_name: :"solid-clipboard-list-check-circle-plus", preset: :kit),
    IconDefinition.new(method_name: :edit_job_task_icon, icon_name: :"solid-clipboard-list-check-pen", preset: :kit),

    IconDefinition.new(method_name: :job_task_label_icon, icon_name: :scribble, preset: :solid),
    IconDefinition.new(method_name: :todo_icon, icon_name: :circle, preset: :regular),
    IconDefinition.new(method_name: :done_icon, icon_name: :"circle-check", preset: :duotone),
    IconDefinition.new(method_name: :cancelled_icon, icon_name: :"circle-xmark", preset: :duotone),

    IconDefinition.new(method_name: :job_task_type_label_icon, icon_name: :bucket, preset: :duotone),

    IconDefinition.new(method_name: :estimated_duration_icon, icon_name: :"face-thinking", preset: :duotone),

    IconDefinition.new(method_name: :formatted_address_icon, icon_name: :"map-pin", preset: :duotone),
  ])

  def self.offsite_icon = organization_icon
  def self.edit_onsite_icon = onsite_icon

  def self.job_status_icon(status:)
    case status.to_sym
    when :active
      active_icon
    when :archived
      archived_icon
    end
  end

  def self.onsite_status_icon(status:)
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

  def self.onsite_priority_icon(priority:)
    case priority.to_sym
    when :regular_priority
      regular_priority_icon
    when :high_priority
      high_priority_icon
    end
  end

  def self.job_task_status_icon(status:)
    case status.to_sym
    when :todo
      todo_icon
    when :done
      done_icon
    when :cancelled
      cancelled_icon
    end
  end

  def self.job_task_type_icon(task_type:)
    case task_type.to_sym
    when :onsite
      onsite_icon
    when :offsite
      offsite_icon
    end
  end

  def self.membership_type_icon(membership_type:)
    case membership_type.to_sym
    when :staff
      badge_icon
    when :organization_manager
      organization_manager_icon
    end
  end

  def self.help_icon_with_tooltip(id:)
    duotone_icon(
      name: "circle-info",
      options: {id: id}
    )
  end
end