# frozen_string_literal: true

module Organizations::NotesHelper
  def note_resource_icon(note:)
    case note.resource
    when Organization::Job
      job_icon
    when Organization::Onsite
      onsite_icon
    else
      raise ArgumentError
    end
  end

  def note_resource_title(note:)
    case note.resource
    when Organization::Job
      note.resource.name
    when Organization::Onsite
      note.resource.label
    else
      raise ArgumentError
    end
  end

  def note_resource_url(note:)
    case note.resource
    when Organization::Job
      organization_job_url(note.organization, note.resource)
    when Organization::Onsite
      onsite_url(note.organization, note.resource)
    else
      raise ArgumentError
    end
  end
end
