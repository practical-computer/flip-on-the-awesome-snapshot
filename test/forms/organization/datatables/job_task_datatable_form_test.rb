# frozen_string_literal: true

require "test_helper"

class   Test < ActiveSupport::TestCase
  test "includes the underlying modules" do
    assert_equal true, Organization::Datatables::JobTaskDatatableForm.include?(ActiveModel::API)
    assert_equal true, Organization::Datatables::JobTaskDatatableForm.include?(ActiveModel::Validations::Callbacks)
    assert_equal true, Organization::Datatables::JobTaskDatatableForm.include?(PracticalFramework::Forms::DatatableForm)
  end

  test "filters class has the label, task_type, status attributes" do
    label = Faker::Company.name
    status = Faker::Subscription.status
    task_type = Faker::Hacker.verb
    filter_instance = Organization::Datatables::JobTaskDatatableForm::Filters.new(label: label, status: status, task_type: task_type)

    assert_equal label, filter_instance.label
    assert_equal status, filter_instance.status
    assert_equal task_type, filter_instance.task_type
  end

  test "filters class has an errors instance" do
    label = Faker::Company.name
    status = Faker::Subscription.status
    filter_instance = Organization::Datatables::JobTaskDatatableForm::Filters.new(label: label, status: status)

    assert_kind_of ActiveModel::Errors, filter_instance.errors
  end

  test "filter_class returns the correct class" do
    assert_equal Organization::Datatables::JobTaskDatatableForm::Filters, Organization::Datatables::JobTaskDatatableForm.filter_class
  end

  test "default_payload" do
    expected = {
      sort_key: "status",
      sort_direction: "asc",
      filters: {
        status: ["todo", "done"],
        task_type: ["onsite", "offsite"]
      }
    }

    assert_equal expected, Organization::Datatables::JobTaskDatatableForm.default_payload
  end

  test "schema: valid if no filters are provided" do
    payload = {
      sort_key: "status",
      sort_direction: "asc",
    }

    assert_equal true, Organization::Datatables::JobTaskDatatableForm.schema.validate?(payload)
  end

  test "schema: validates the sort_key" do
    payload = {
      sort_key: "organization_id",
      sort_direction: "asc",
      filters: {
        status: ["active"]
      }
    }

    schema = Organization::Datatables::JobTaskDatatableForm.schema
    assert_equal false, schema.validate?(payload)
    assert_equal ["not an accepted value"], schema.errors["sort_key"]
  end

  test "schema: validates the sort_direction" do
    payload = {
      sort_key: "status",
      sort_direction: "ascending",
      filters: {
        status: ["active"]
      }
    }

    schema = Organization::Datatables::JobTaskDatatableForm.schema
    assert_equal false, schema.validate?(payload)
    assert_equal ["not an accepted value"], schema.errors["sort_direction"]
  end

  test "schema: validates the filter values" do
    payload = {
      sort_key: "status",
      sort_direction: "desc",
      filters: {
        status: [nil]
      }
    }

    schema = Organization::Datatables::JobTaskDatatableForm.schema
    assert_equal false, schema.validate?(payload)
    assert_equal ({"status" => { "0" => ["nil object not allowed"] }}), schema.errors["filters"]
  end
end