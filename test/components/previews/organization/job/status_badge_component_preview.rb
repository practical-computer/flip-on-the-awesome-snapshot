# frozen_string_literal: true

class Organization::Job::StatusBadgeComponentPreview < ViewComponent::Preview
  def active
    render(Organization::Job::StatusBadgeComponent.new(job: :active))
  end

  def archived
    render(Organization::Job::StatusBadgeComponent.new(job: :archived))
  end
end
