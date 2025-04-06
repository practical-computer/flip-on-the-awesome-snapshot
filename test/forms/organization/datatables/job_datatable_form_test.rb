# frozen_string_literal: true

require "test_helper"

class Organization::Datatables::JobDatatableFormTest < ActiveSupport::TestCase
  test "includes the underlying modules" do
    assert_equal true, Organization::Datatables::JobDatatableForm.include?(ActiveModel::API)
    assert_equal true, Organization::Datatables::JobDatatableForm.include?(ActiveModel::Validations::Callbacks)
    assert_equal true, Organization::Datatables::JobDatatableForm.include?(PracticalFramework::Forms::DatatableForm)
  end

  test "filters class has the job_name and status attributes" do
    job_name = Faker::Company.name
    status = Faker::Subscription.status
    filter_instance = Organization::Datatables::JobDatatableForm::Filters.new(job_name: job_name, status: status)

    assert_equal job_name, filter_instance.job_name
    assert_equal status, filter_instance.status
  end

  test "filters class has an errors instance" do
    job_name = Faker::Company.name
    status = Faker::Subscription.status
    filter_instance = Organization::Datatables::JobDatatableForm::Filters.new(job_name: job_name, status: status)

    assert_kind_of ActiveModel::Errors, filter_instance.errors
  end

  test "filter_class returns the correct class" do
    assert_equal Organization::Datatables::JobDatatableForm::Filters, Organization::Datatables::JobDatatableForm.filter_class
  end

  test "default_payload" do
    expected = {
      sort_key: "status",
      sort_direction: "asc",
      filters: {
        status: ["active"]
      }
    }

    assert_equal expected, Organization::Datatables::JobDatatableForm.default_payload
  end

  test "schema: valid if no filters are provided" do
    payload = {
      sort_key: "status",
      sort_direction: "asc",
    }

    assert_equal true, Organization::Datatables::JobDatatableForm.schema.validate?(payload)
  end

  test "schema: validates the sort_key" do
    payload = {
      sort_key: "organization_id",
      sort_direction: "asc",
      filters: {
        status: ["active"]
      }
    }

    schema = Organization::Datatables::JobDatatableForm.schema
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

    schema = Organization::Datatables::JobDatatableForm.schema
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

    schema = Organization::Datatables::JobDatatableForm.schema
    assert_equal false, schema.validate?(payload)
    assert_equal ({"status" => { "0" => ["nil object not allowed"] }}), schema.errors["filters"]
  end
end