# frozen_string_literal: true

class PracticalViews::Navigation::NavigationLinkComponentPreview < ViewComponent::Preview
  def default
    render_with_template(locals: {selected: false})
  end

  def selected
    render_with_template(template: "practical_views/navigation/navigation_link_component_preview/default", locals: {selected: true})
  end

  def no_icon
    render(PracticalViews::Navigation::NavigationLinkComponent.new(
      href: "example.com",
      selected: false
    ).with_content("Hello World"))
  end
end
