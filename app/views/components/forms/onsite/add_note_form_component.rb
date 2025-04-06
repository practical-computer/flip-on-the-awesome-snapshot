# frozen_string_literal: true

class Forms::Onsite::AddNoteFormComponent < ApplicationComponent
  attr_accessor :form

  delegate :current_organization, to: :helpers

  def initialize(form:)
    @form = form
  end
end
