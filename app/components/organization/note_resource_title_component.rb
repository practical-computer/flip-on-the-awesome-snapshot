# frozen_string_literal: true

class Organization::NoteResourceTitleComponent < Phlex::HTML
  attr_accessor :note

  def initialize(note:)
    self.note = note
  end

  def view_template
    header(class: 'cluster-compact') {
      a(href: helpers.note_resource_url(note: note)) {
        unsafe_raw helpers.note_resource_icon(note: note)
        whitespace
        unsafe_raw helpers.note_resource_title(note: note)
      }
    }
  end
end