# frozen_string_literal: true

class Users::ThemeController < Users::BaseController
  def update
    current_user.update!(theme_update_params)

    message = t('user_settings.theme.updated_message')

    if using_web_awesome?
      icon = helpers.icon_set.theme_icon
    else
      icon = helpers.theme_icon
    end

    flash[:notice] = flash_notice_with_icon(message: message, icon: icon)

    redirect_to edit_user_registration_url(current_user)
  end

  def theme_update_params
    params.require(:user_theme).permit(:theme)
  end
end
