# frozen_string_literal: true

SimpleCov.start "rails" do
  enable_coverage :branch
  add_group "Policies", "app/policies"
  add_group "Phlex Components", "app/components"
  add_group "Form models", "app/forms"
  add_group "Service classes", "app/services"
  add_group "Relation Builders", "app/relation_builders"

  command_name "Job #{ENV['CIRCLE_JOB']} #{ENV['CIRCLE_NODE_INDEX']}" if ENV['CIRCLE_NODE_INDEX']

  if ENV['CI']
    formatter SimpleCov::Formatter::SimpleFormatter
  else
    formatter SimpleCov::Formatter::MultiFormatter.new(
      [
        SimpleCov::Formatter::SimpleFormatter,
        SimpleCov::Formatter::HTMLFormatter
      ]
    )
  end
end
