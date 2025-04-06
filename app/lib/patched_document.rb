# frozen_string_literal: true

class PatchedDocument < PracticalFramework::Components::TiptapDocument
  def render_node(node:)
    begin
      super
    rescue UnknownNodeTypeError => e
      Honeybadger.notify(e)
    end
  end

  class HardBreak < Phlex::HTML
    def view_template
      br
    end
  end
end