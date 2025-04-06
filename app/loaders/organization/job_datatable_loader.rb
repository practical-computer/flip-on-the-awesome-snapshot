# frozen_string_literal: true

class Organization::JobDatatableLoader < PracticalFramework::Loaders::Base
  alias_method :jobs, :records

  def build_datatable_form
    Organization::Datatables::JobDatatableForm.new(datatable_payload)
  end

  def build_relation_builder
    Organization::JobRelationBuilder.new(payload: datatable_form.payload,
                                         relation: base_relation
                                        )
  end

  def default_payload
    Organization::Datatables::JobDatatableForm.default_payload
  end
end