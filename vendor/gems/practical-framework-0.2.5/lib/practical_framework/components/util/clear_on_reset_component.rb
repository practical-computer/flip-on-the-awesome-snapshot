# frozen_string_literal: true

class PracticalFramework::Components::Util::ClearOnResetComponent < Phlex::HTML
  register_element :clear_on_reset

  def view_template
    clear_on_reset {
      yield
    }
  end
end