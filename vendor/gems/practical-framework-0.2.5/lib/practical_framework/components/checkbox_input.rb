# frozen_string_literal: true

class PracticalFramework::Components::CheckboxInput < Phlex::HTML
  include PracticalFramework::Components::WrappedToggle
  attr_accessor :id

  def default_label_classes
    ["checkbox-input", "card", "with-sidebar", "no-max-inline-size", "springed-toggle"]
  end

  def initialize(id:)
    self.id = id
  end

  def input_classes(classes: nil)
    tokens(["compact-size", "rounded", "raised", "raised-labeling"] + Array.wrap(classes))
  end
end
