# frozen_string_literal: true

class Organization::Datatables::JobDatatableForm
  include ActiveModel::API
  include ActiveModel::Validations::Callbacks
  include PracticalFramework::Forms::DatatableForm

  Filters = Struct.new(:job_name, :status, keyword_init: true) do
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
        status: ["active"]
      }
    }
  end

  def self.schema
    DuckHunt::Schemas::HashSchema.define(strict_mode: false) do |x|
      x.string "sort_key", accepted_values: ["name", "status"], required: false, allow_nil: false
      x.string "sort_direction", accepted_values: ["asc", "desc"], required: false, allow_nil: false
      x.nested_hash "filters", strict_mode: false, required: false do |filters|
        filters.string "job_name", required: false, allow_nil: false
        filters.array "status" do |array|
          array.string accepted_values: Organization::Job.statuses.keys, required: false, allow_nil: false
        end
      end
    end
  end
end