# frozen_string_literal: true

class Navigation::MainApp::HomeSection < PracticalFramework::Components::TabbedFrame::NavigationSection
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag
  attr_accessor :current_user, :current_organization, :items

  def initialize(current_user:, current_organization:)
    self.current_user = current_user
    self.current_organization = current_organization
    super()
    render_section
  end

  def active_memberships
    @active_memberships ||= current_user.memberships.active
  end

  def render_section
    if current_user.memberships.empty?
      no_memberships_section
      return
    end

    if current_organization.present?
      render_organization_section(organization: current_organization)
      return
    end

    if active_memberships.one?
      organization = current_user.organizations.first
      render_organization_section(organization: organization)
      return
    end

    no_memberships_section
    return
  end

  def no_memberships_section
    return nil
  end

  def quick_organization_list
    if (2...3).cover?(active_memberships.size)
      section(class: "compact-font") do
        ordered_organizations.each do |organization|
          render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
            href: helpers.organization_url(organization),
            selected: (:organization == helpers.main_application_navigation_link_key)
          ) do |link|
            link.unsafe_raw(helpers.warehouse_icon)
            link.whitespace
            link.plain(organization.name)
          end
        end
      end

      hr
    end
  end

  def ordered_organizations
    @ordered_organizations ||= current_user.organizations.order(name: :asc).where(memberships: active_memberships)
  end

  def change_organization_link
    render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
      href: helpers.organizations_url,
      selected: (:organizations == helpers.main_application_navigation_link_key)
    ) do |link|
      link.unsafe_raw(helpers.icon(style: "fa-duotone fa-fw", name: "swap"))
      link.span{ helpers.t("app_navigation.home_section.change_organizations_title") }
    end
  end

  def render_organization_section(organization:)
    self.title do
      h2(class: "cluster-compact") do |title|
        helpers.warehouse_icon
        title.whitespace
        title.plain(organization.name)
      end
    end

    self.with_item do |section|
      render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.organization_url(current_organization),
        selected: (:organization == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(helpers.icon(style: "fa-solid fa-fw", name: "home"))
        link.span{ helpers.t("app_navigation.user_settings.home_title") }
      end
    end

    self.with_item do |section|
      render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.organization_jobs_url(current_organization),
        selected: (:organization_jobs == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(helpers.job_icon)
        link.span{ helpers.t("app_navigation.home_section.jobs_title") }
      end
    end

    self.with_item do |section|
      render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.organization_notes_url(current_organization),
        selected: (:organization_notes == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(helpers.notes_icon)
        link.span{ helpers.t("app_navigation.home_section.notes_title") }
      end
    end

    self.with_item do |section|
      hr

      render PracticalFramework::Components::TabbedFrame::NavigationLink.new(
        href: helpers.organization_memberships_url(current_organization),
        selected: (:organization_memberships == helpers.main_application_navigation_link_key)
      ) do |link|
        link.unsafe_raw(helpers.icon(style: "fa-solid fa-fw", name: "hexagon"))
        link.span{ helpers.t("app_navigation.home_section.memberships_title") }
      end
    end

    self.with_item do |section|
      hr
      change_organization_link
    end

    self.with_item do |section|
      quick_organization_list
    end
  end
end