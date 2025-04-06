# frozen_string_literal: true

class Organization::Onsite::NotesComponent < ApplicationComponent
  attr_accessor :onsite, :note_form

  def initialize(onsite:, note_form:)
    @onsite = onsite
    @note_form = note_form
  end
end
