# frozen_string_literal: true

class V2::Organization::NoteComponent < ApplicationComponent
  renders_one :resource_link
  renders_one :actions
  attr_accessor :note

  def initialize(note:)
    @note = note
  end
end
