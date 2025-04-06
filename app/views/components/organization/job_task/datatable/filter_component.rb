# frozen_string_literal: true

class Organization::JobTask::Datatable::FilterComponent < ApplicationComponent
  include PracticalViews::Datatable::FilterApplied
  attr_accessor :datatable_form, :url

  def initialize(datatable_form:, url:)
    @datatable_form = datatable_form
    @url = url
  end

  def dialog_id
    "job-task-datatable-filter"
  end
end
