# frozen_string_literal: true

class PracticalFramework::Components::RadioInput < Phlex::HTML
  include PracticalFramework::Components::WrappedToggle
  attr_accessor :id

  def initialize(id:)
    self.id = id
  end

  def input_classes(classes: nil)
    tokens(["circle", "raised", "raised-labeling"] + Array.wrap(classes))
  end
end
