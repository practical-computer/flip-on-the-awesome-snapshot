# frozen_string_literal: true

class Navigation::MainApp::UserSettingsSection < PracticalFramework::Components::TabbedFrame::NavigationSection
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag
  attr_accessor :current_user

  def initialize(current_user:)
    self.current_user = current_user
    super()
    render_section
  end

  def render_section
    self.title do |section|
      section.h2(class: "cluster-compact") do |title|
        title.span{ icon(style: "fa-duotone", name: "user") }
        title.whitespace
        title.plain(current_user.name)
      end
    end

    self.with_item do |section|
      section.render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.edit_user_registration_url,
        selected: (:user_profile == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(icon(style: "fa-solid fa-fw", name: "id-card"))
        link.span{ helpers.t("app_navigation.user_settings.profile_title") }
      end
    end

    self.with_item do |section|
      section.render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.user_memberships_url,
        selected: (:user_memberships == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(icon(style: "fa-solid fa-fw", name: "hexagon"))
        link.span{ helpers.t("app_navigation.user_settings.memberships_title") }
      end
    end

    self.with_item do |section|
      section.render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.destroy_user_session_url,
        selected: false
      ) do |link|
        link.unsafe_raw(helpers.sign_out_icon)
        link.span{ helpers.t("app_navigation.user_settings.signout_title") }
      end
    end
  end
end