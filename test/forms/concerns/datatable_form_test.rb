# frozen_string_literal: true

require "test_helper"

class DatatableFormTest < ActiveSupport::TestCase
  class TestClass
    include ActiveModel::API
    include ActiveModel::Validations::Callbacks
    include PracticalFramework::Forms::DatatableForm

    Filters = Struct.new(:column_a, :column_b, keyword_init: true) do
      def errors
        ActiveModel::Errors.new(self)
      end
    end

    def self.filter_class
      Filters
    end

    def self.default_payload
      return {
        sort_key: "column_a",
        sort_direction: "asc",
        filters: {
          column_a: ["active"]
        }
      }
    end

    def self.schema
      DuckHunt::Schemas::HashSchema.define(strict_mode: false) do |x|
        x.string "sort_key", accepted_values: ["column_a", "column_b"], required: false, allow_nil: false
        x.string "sort_direction", accepted_values: ["asc", "desc"], required: false, allow_nil: false
        x.nested_hash "filters", strict_mode: false, required: false do |filters|
          filters.string "column_b", required: false, allow_nil: true
          filters.array "column_a", required: false do |array|
            array.string accepted_values: ["active", "inactive"], required: false, allow_nil: false
          end
        end
      end
    end
  end

  def valid_instance
    TestClass.new(filters: {column_b: Faker::Company.name, column_a: ["inactive"]}, sort_key: "column_a", sort_direction: "desc")
  end

  test "initialize: calls sanitize! to sanitize the payload against the schema" do
    spy = Spy.on_instance_method(TestClass, :sanitize!).and_call_through
    valid_instance
    assert_times_called(spy: spy, times: 1)
  end

  test "initialize: transforms the filters hash to an instance of the filter_class" do
    instance = TestClass.new(sort_key: "column_a", sort_direction: "desc", filters: { column_b: "Hello"})

    assert_kind_of TestClass::Filters, instance.filters
  end

  test "initialize: falls back to the default_payload if given an invalid payload" do
    instance = TestClass.new(sort_key: "column_c", sort_direction: "desc", filters: { column_b: "Hello"})
    default_instance = TestClass.new(TestClass.default_payload)
    assert_equal default_instance.payload, instance.payload
  end

  test "sanitized?: returns true if sanitized is true" do
    instance = valid_instance
    assert_equal true, instance.sanitized
    assert_equal true, instance.sanitized?
  end

  test "payload: generates a hash version of the form's payload for a relation_builder" do
    instance = valid_instance

    column_b_value = instance.filters[:column_b]

    expected = {
      sort_key: "column_a",
      sort_direction: "desc",
      filters: {
        column_b: column_b_value,
        column_a: ["inactive"]
      }
    }

    assert_equal expected, instance.payload
  end

  test "payload: generates a hash version, even if there are no provided filters" do
    instance = TestClass.new(sort_key: "column_a", sort_direction: "desc")
    assert_nil instance.filters

    expected = {
      sort_key: "column_a",
      sort_direction: "desc",
      filters: {}
    }

    assert_equal expected, instance.payload
  end

  test "merged_payload: returns the original payload if no changes are provided" do
    instance = valid_instance

    expected = instance.payload

    assert_equal expected, instance.merged_payload
  end

  test "merged_payload: merges the filters with the changes provided" do
    instance = valid_instance

    expected =  {
      sort_key: "column_a",
      sort_direction: "desc",
      filters: {
        column_b: "New Value",
        column_a: ["inactive"]
      }
    }

    assert_equal expected, instance.merged_payload(filters: {column_b: "New Value"})
  end

  test "merged_payload: changes the sort_key if present, leaving the filters untouched" do
    instance = valid_instance

    column_b_value = instance.filters[:column_b]

    expected = {
      sort_key: "column_b",
      sort_direction: "desc",
      filters: {
        column_b: column_b_value,
        column_a: ["inactive"]
      }
    }

    assert_equal expected, instance.merged_payload(sort_key: "column_b")
  end

  test "merged_payload: changes the sort_direction if present, leaving the filters untouched" do
    instance = valid_instance

    column_b_value = instance.filters[:column_b]

    expected = {
      sort_key: "column_a",
      sort_direction: "asc",
      filters: {
        column_b: column_b_value,
        column_a: ["inactive"]
      }
    }

    assert_equal expected, instance.merged_payload(sort_direction: "asc")
  end

  test "merged_payload: changes all the attributes as expected if all are provided" do
    instance = valid_instance

    expected =  {
      sort_key: "column_b",
      sort_direction: "asc",
      filters: {
        column_b: "New Value",
        column_a: ["inactive"]
      }
    }

    assert_equal expected, instance.merged_payload(
      filters: {column_b: "New Value"},
      sort_direction: "asc",
      sort_key: "column_b"
    )
  end

  test "sanitize!: validates the form and marks the sanitized attribute as true" do
    instance = valid_instance
    instance.sanitized = false
    instance.errors.clear

    instance.sanitize!

    assert_equal true, instance.sanitized
    assert_equal true, instance.valid?
  end

  test "sanitize!: falls back to the default_payload if given an invalid payload and marks as sanitized" do
    instance = valid_instance
    instance.sanitized = false
    instance.errors.clear
    instance.filters = TestClass::Filters.new(column_b: "Testing")
    instance.sanitize!

    assert_equal true, instance.sanitized
    assert_equal true, instance.valid?

    instance.filters = instance.class.filter_class.new(instance.filters)

    default_instance = TestClass.new(TestClass.default_payload)
    assert_equal default_instance.payload, instance.payload
  end

  test "sort_direction_for: returns nil if the provided key does not match the current sort_key" do
    instance = valid_instance
    assert_equal "desc", instance.sort_direction

    assert_not_equal "column_b", instance.sort_key
    assert_nil instance.sort_direction_for(key: "column_b")
  end

  test "sort_direction_for: returns the sort_direction if the provided key matches the current sort_key" do
    instance = valid_instance
    assert_equal "desc", instance.sort_direction

    assert_equal "column_a", instance.sort_key
    assert_equal "desc", instance.sort_direction_for(key: "column_a")
  end

  test "inverted_sort_direction_for: returns asc if the provided key does not match the current sort_key" do
    instance = valid_instance
    assert_equal "desc", instance.sort_direction

    assert_not_equal "column_b", instance.sort_key
    assert_equal "asc", instance.inverted_sort_direction_for(key: "column_b")
  end

  test "inverted_sort_direction_for: returns the inverted sort_direction if the provided key matches the current sort_key" do
    instance = valid_instance
    assert_equal "desc", instance.sort_direction

    assert_equal "column_a", instance.sort_key
    assert_equal "asc", instance.inverted_sort_direction_for(key: "column_a")
  end

  test "normalize_sort_key_and_direction: strips and downcases the provided sort_key and sort_direction" do
    instance = valid_instance

    instance.sort_key = "    ColUmN_A \t\t\n "
    instance.sort_direction = "    ASC"

    instance.normalize_sort_key_and_direction

    assert_equal "column_a", instance.sort_key
    assert_equal "asc", instance.sort_direction
  end

  test "matches_schema?: does nothing if the payload is valid according to the schema" do
    instance = valid_instance
    assert_nil instance.matches_schema?
    assert_empty instance.errors
  end

  test "matches_schema?: adds a payload_does_not_match_schema error if the payload is invalid" do
    instance = valid_instance
    instance.sort_key = "column_c"

    instance.matches_schema?

    assert_equal true, instance.errors.of_kind?(:base, :payload_does_not_match_schema)
  end
end