# frozen_string_literal: true

class Navigation::NavigationLinkComponentPreview < ViewComponent::Preview
  def no_icon
    render(Navigation::NavigationLinkComponent.new(
      href: "example.com",
      selected: false
    ).with_content("Hello World"))
  end
end
