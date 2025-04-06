# frozen_string_literal: true

require "test_helper"

class PracticalViews::IconForFileExtensionComponentTest < ViewComponentTestCase
  def assert_icon_rendered(expected_icon:, extension:)
    actual = render_inline PracticalViews::IconForFileExtensionComponent.new(extension: extension)
    assert_equal 1, actual.children.size

    assert_equal render_inline(expected_icon).to_html, actual.children[0].to_html
  end

  test "renders supported extensions" do
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.csv_icon, extension: :csv)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.xls_icon, extension: :xls)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.xls_icon, extension: :xlsx)

    assert_icon_rendered(expected_icon: PracticalViews::IconSet.doc_icon, extension: :doc)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.doc_icon, extension: :docx)

    assert_icon_rendered(expected_icon: PracticalViews::IconSet.pdf_icon, extension: :pdf)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.heic_icon, extension: :heic)

    assert_icon_rendered(expected_icon: PracticalViews::IconSet.txt_icon, extension: :txt)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.txt_icon, extension: :rtf)
  end

  test "renders the special missing extension" do
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.missing_file_icon, extension: :missing)
  end

  test "renders the fallback file icon if trying to render an extension we somehow do not have an icon for" do
    Spy.on(PracticalViews::IconForFileExtensionComponent, supported_extension?: true)
    assert_icon_rendered(expected_icon: PracticalViews::IconSet.txt_icon, extension: :png)
  end

  test "initialize raises an ArgumentError if given an invalid extension" do
    assert_raises ArgumentError do
      PracticalViews::IconForFileExtensionComponent.new(extension: "png")
    end
  end

  test "supported_extension?" do
    accepted = %i(
      csv
      pdf
      docx
      xlsx
      doc
      xls
      heic
      txt
      rtf
    )

    accepted.each do |extension|
      assert_equal true, PracticalViews::IconForFileExtensionComponent.supported_extension?(extension: extension), extension
    end

    not_accepted = %i(
      rb
      png
      gif
      jpeg
      blah
    )

    not_accepted.each do |extension|
      assert_equal false, PracticalViews::IconForFileExtensionComponent.supported_extension?(extension: extension), extension
    end
  end
end
