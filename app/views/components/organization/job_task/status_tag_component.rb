# frozen_string_literal: true

class Organization::JobTask::StatusTagComponent < ApplicationComponent
  include Organization::JobTask::StatusColorVariant
  attr_accessor :status

  def initialize(status:)
    @status = status
  end

  def call
    tag.wa_tag(variant: color_variant(status: status).to_web_awesome) {
      helpers.icon_text(
        icon: helpers.icon_set.job_task_status_icon(status: status),
        text: helpers.human_job_task_status(status: status),
        options: {class: "wa-gap-xs"}
      )
    }
  end
end
