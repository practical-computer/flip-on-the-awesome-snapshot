# frozen_string_literal: true

class PracticalFramework::Components::ShareLink < Phlex::HTML
  attr_accessor :url, :share_button_title

  def initialize(url:, share_button_title: nil)
    self.url = url
    self.share_button_title = share_button_title
  end

  def view_template
    section(class: 'stack-compact') {
      h2{
        unsafe_raw helpers.share_icon
        whitespace
        plain share_title
      }

      a(href: url, style: "word-break: break-all;", target: "_blank"){ url }
    }
  end

  def share_title
    (share_button_title || helpers.t("share_button.title"))
  end
end