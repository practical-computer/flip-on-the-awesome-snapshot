# frozen_string_literal: true

class Organization::Datatables::JobTaskDatatableForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include PracticalFramework::Forms::DatatableForm

  Filters = Struct.new(:label, :task_type, :status, keyword_init: true) do
    def errors
      ActiveModel::Errors.new(self)
    end
  end

  def self.filter_class
    Filters
  end

  def self.default_payload
    return {
      sort_key: "status",
      sort_direction: "asc",
      filters: {
        status: ["todo", "done"],
        task_type: ["onsite", "offsite"]
      }
    }
  end

  def self.schema
    DuckHunt::Schemas::HashSchema.define(strict_mode: false) do |x|
      x.string("sort_key",
               accepted_values: ["label", "task_type", "status", "onsite_label", "estimated_minutes"],
               required: false,
               allow_nil: false
             )

      x.string "sort_direction", accepted_values: ["asc", "desc"], required: false, allow_nil: false
      x.nested_hash "filters", strict_mode: false, required: false do |filters|
        filters.string "label", required: false, allow_nil: false
        filters.array "task_type", required: false do |array|
          array.string accepted_values: Organization::JobTask.task_types.keys, required: false, allow_nil: false
        end
        filters.array "status" do |array|
          array.string accepted_values: Organization::JobTask.statuses.keys, required: false, allow_nil: false
        end
      end
    end
  end
end