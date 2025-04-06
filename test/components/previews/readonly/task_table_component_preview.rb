# frozen_string_literal: true

class Readonly::TaskTableComponentPreview < ViewComponent::Preview
  def default
    render(Readonly::TaskTableComponent.new(job_tasks: "job_tasks"))
  end
end
