# frozen_string_literal: true

module PatchedFlashHelpers
  extend ActiveSupport::Concern

  def default_notice_icon
    if using_web_awesome?
      return helpers.icon_set.info_icon
    else
      return helpers.icon(style: 'fa-duotone', name: 'circle-info')
    end
  end

  def default_alert_icon
    if using_web_awesome?
      return helpers.icon_set.alert_icon
    else
      return helpers.icon(style: 'fa-duotone', name: 'triangle-exclamation')
    end
  end

  def default_success_icon
    if using_web_awesome?
      return helpers.icon_set.success_icon
    else
      return helpers.icon(style: 'fa-duotone', name: 'circle-check')
    end
  end
end