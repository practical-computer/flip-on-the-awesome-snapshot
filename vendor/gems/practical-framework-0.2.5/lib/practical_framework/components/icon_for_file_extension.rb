# frozen_string_literal: true

class PracticalFramework::Components::IconForFileExtension < Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::ContentFor

  attr_reader :extension

  def initialize(extension:)
    raise ArgumentError unless self.class.supported_extension?(extension: extension)
    @extension = extension.to_sym
  end

  def view_template
    case extension
    when :csv
      cached_icon(symbol_name: :"csv-icon", style: "fa-duotone", name: "file-csv")
    when :pdf
      cached_icon(symbol_name: :"pdf-icon", style: "fa-duotone", name: "file-pdf")
    when :doc, :docx
      cached_icon(symbol_name: :"doc-icon", style: "fa-duotone", name: "file-doc")
    when :xls, :xlsx
      cached_icon(symbol_name: :"xls-icon", style: "fa-duotone", name: "file-xls")
    when :heic
      cached_icon(symbol_name: :"heic-icon", style: "fa-duotone", name: "file-image")
    when :missing
      cached_icon(symbol_name: :"missing-file-icon", style: "fa-solid", name: "file-slash")
    else
      cached_icon(symbol_name: :"txt-icon", style: "fa-duotone", name: "file")
    end
  end

  def self.supported_extension?(extension:)
    supported_extensions.include?(extension.to_sym)
  end

  def self.supported_extensions
    %i(
       csv
       pdf
       docx
       xlsx
       doc
       xls
       heic
       missing
       txt
       rtf
       numbers
    ).freeze
  end
end