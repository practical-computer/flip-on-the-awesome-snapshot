# frozen_string_literal: true

class Organization::NoteComponent < Phlex::HTML
  attr_accessor :note

  def initialize(note:)
    self.note = note
  end

  def view_template
    blockquote(**classes("note", "tiptap-document")) {
      header(class: 'cluster-compact') {
        author_details
        note_metadata
      }

      render document
    }
  end

  def document
    PatchedDocument.new(document: note.tiptap_document)
  end

  def author_details
    section {
      render Organization::UserLabel.new(user: note.original_author)
    }
  end

  def note_metadata
    section(class: 'cluster-compact') {
      span {
        whitespace
        unsafe_raw "&middot;"
        whitespace
        render Organization::TimeTag.new(date_or_time: note.created_at, organization: note.organization)
      }

      if note.created_at != note.updated_at
        span{
          unsafe_raw "&middot;"
          whitespace
          render Organization::TimeTag.new(date_or_time: note.updated_at, organization: note.organization)
        }
      end
    }
  end
end