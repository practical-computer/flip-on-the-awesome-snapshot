# frozen_string_literal: true

SimpleCov.start do
  enable_coverage :branch

  add_filter '/test/'
  add_filter '/config/'
  add_filter '/lib/practical_framework/test_helpers/'
  add_group "Components", "lib/practical_framework/components"
  add_group "Controller code", "lib/practical_framework/controllers"
  add_group "Form Builders", "lib/practical_framework/form_builders"
  add_group "Forms", "lib/practical_framework/forms"
  add_group "Loaders", "lib/practical_framework/loaders"
  add_group "Relation Builders", "lib/practical_framework/relation_builders"
  add_group "View Helpers", "lib/practical_framework/view_helpers"
  add_group "General Library Code", "lib"

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
