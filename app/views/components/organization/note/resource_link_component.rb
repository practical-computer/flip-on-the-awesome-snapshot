# frozen_string_literal: true

class Organization::Note::ResourceLinkComponent < ApplicationComponent
  attr_accessor :note
  delegate :organization, to: :helpers

  def initialize(note:)
    @note = note
  end

  def call
    case note.resource
    when Organization::Job
      link_to(organization_job_url(current_organization, note.resource)){
        icon_text(icon: icon_set.job_icon, text: note.resource.name)
      }
    when Organization::Onsite
      link_to(onsite_url(current_organization, note.resource)){
        icon_text(icon: icon_set.onsite_icon, text: note.resource.label)
      }
    else
      return nil
    end
  end
end
