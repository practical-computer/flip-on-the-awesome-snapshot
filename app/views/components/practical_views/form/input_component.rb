# frozen_string_literal: true

class PracticalViews::Form::InputComponent < ViewComponent::Base
  attr_accessor :f, :object_method, :label_options

  renders_one :label
  renders_one :field

  def initialize(f:, object_method:, label_options: {})
    self.f = f
    self.object_method = object_method
    self.label_options = label_options
  end
end
