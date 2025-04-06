# frozen_string_literal: true

class Forms::JobFormComponent < ApplicationComponent
  attr_accessor :form

  def initialize(form:)
    @form = form
  end
end
