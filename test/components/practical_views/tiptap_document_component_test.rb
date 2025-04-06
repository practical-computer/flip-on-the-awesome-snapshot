# frozen_string_literal: true

require "test_helper"

class PracticalViews::TiptapDocumentComponentTest < ViewComponentTestCase
  include PracticalFramework::TestHelpers::ShrineTestData

  def class_name
    PracticalViews::TiptapDocumentComponent
  end

  def open_test_file(filename:)
    JSON.parse(File.read(file_fixture(File.join("tiptap_documents", filename))))
  end

  def assert_heading_level_rendered(expected_level:)
    expected = Faker::Movie.title
    node = {
      type: "heading",
      attrs: {
        level: expected_level
      },
      content: [
        {
          type: "text",
          text: expected
        },
      ]
    }

    actual = render_inline class_name::Heading.new(node_content: node)

    assert_equal 1, actual.children.size
    assert_equal "h#{expected_level}", actual.children.first.name
    assert_equal expected, actual.text
  end

  test "raises ArgumentError if a non-document is provided" do
    bad_document = {type: "blah", content: []}

    assert_raises ArgumentError do
      class_name.new(document: bad_document)
    end
  end

  test "text: renders plain text" do
    expected = Faker::Quotes::Chiquito.sentence
    actual = render_inline class_name::Text.new(node_content: {type: "text", text: expected})

    assert_equal 1, actual.children.size
    assert_equal "text", actual.children.first.name
    assert_equal expected, actual.text
  end

  test "text: renders text with italic marks as part of a em element" do
    expected = Faker::Quotes::Chiquito.sentence
    content = {
      type: "text",
      marks: [type: "italic"],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "em", actual.children.first.name
    assert_equal expected, actual.text
  end

  test "text: renders text with bold marks as part of a strong element" do
    expected = Faker::Quotes::Chiquito.sentence
    content = {
      type: "text",
      marks: [type: "bold"],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "strong", actual.children.first.name

    assert_equal expected, actual.text
  end

  test "text: renders text with a rhino-strike mark as part of a del element" do
    expected = Faker::Quotes::Chiquito.sentence
    content = {
      type: "text",
      marks: [type: "rhino-strike"],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "del", actual.children.first.name

    assert_equal expected, actual.text
  end

  test "text: renders text with bold + rhino-strike as part of a del + strong nested element pair" do
    expected = Faker::Quotes::Chiquito.sentence
    content = {
      type: "text",
      marks: [{type: "bold"}, {type: "rhino-strike"}],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "del", actual.children.first.name

    nested_element = actual.children.first
    assert_equal 1, nested_element.children.size
    assert_equal "strong", nested_element.children.first.name

    assert_equal expected, actual.text
  end

  test "text: renders text with a link mark as an anchor element with the rel, target, href attributes" do
    expected = Faker::Quotes::Chiquito.sentence
    url = Faker::Internet.url
    content = {
      type: "text",
      marks: [{ type: "link",
                attrs: {
                  href: url,
                  target: "_blank",
                  rel: "noopener noreferrer nofollow",
                  class: nil
                }
              }],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "a", actual.children.first.name

    link_element = actual.children.first

    assert_equal url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value
    assert_equal "noopener noreferrer nofollow", link_element.attributes["rel"].value
    assert_nil link_element.attributes["class"]
    assert_equal expected, actual.text
  end

  test "text: renders text with bold + link mark as an anchor element with a strong nested element" do
    expected = Faker::Quotes::Chiquito.sentence
    url = Faker::Internet.url
    content = {
      type: "text",
      marks: [
        { type: "link",
          attrs: {
            href: url,
            target: "_blank",
            rel: "noopener noreferrer nofollow",
            class: nil
          }
        },
        {type: "bold"}
      ],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "a", actual.children.first.name

    link_element = actual.children.first

    assert_equal url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value
    assert_equal "noopener noreferrer nofollow", link_element.attributes["rel"].value
    assert_nil link_element.attributes["class"]

    nested_element = actual.children.first
    assert_equal 1, nested_element.children.size
    assert_equal "strong", nested_element.children.first.name

    assert_equal expected, actual.text
  end

  test "text: renders all the supported mark possibilites in the order of rhino-strike, link, bold, italic nested elements" do
    expected = Faker::Quotes::Chiquito.sentence
    url = Faker::Internet.url
    content = {
      type: "text",
      marks: [
        { type: "link",
          attrs: {
            href: url,
            target: "_blank",
            rel: "noopener noreferrer nofollow",
            class: nil
          }
        },
        {type: "bold"},
        {type: "italic"},
        {type: "rhino-strike"}
      ],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size

    strike_element = actual.children.first
    assert_equal "del", strike_element.name

    link_element = strike_element.children.first
    assert_equal "a", link_element.name

    assert_equal url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value
    assert_equal "noopener noreferrer nofollow", link_element.attributes["rel"].value
    assert_nil link_element.attributes["class"]

    bold_element = link_element.children.first
    assert_equal 1, bold_element.children.size
    assert_equal "strong", bold_element.name

    italic_element = bold_element.children.first
    assert_equal 1, italic_element.children.size
    assert_equal "em", italic_element.name

    assert_equal expected, actual.text
  end

  test "text: renders text with bold & italic marks as part of a strong + em nested element pair" do
    expected = Faker::Quotes::Chiquito.sentence
    content = {
      type: "text",
      marks: [{type: "bold"}, {type: "italic"}],
      text: expected
    }
    actual = render_inline class_name::Text.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "strong", actual.children.first.name

    nested_element = actual.children.first
    assert_equal 1, nested_element.children.size
    assert_equal "em", nested_element.children.first.name

    assert_equal expected, actual.text
  end

  test "paragraph: renders an empty paragraph" do
    expected = ""
    actual = render_inline class_name::Paragraph.new(node_content: {type: "paragraph"})

    assert_equal 1, actual.children.size
    assert_equal "p", actual.children.first.name
    assert_equal expected, actual.text
  end

  test "heading: renders h1 through h6" do
    (1...6).each do |level|
      assert_heading_level_rendered(expected_level: level)
    end
  end

  test "blockquote: renders a blockquote with the nested content" do
    expected = Faker::Quotes::Chiquito.sentence

    content = {
      type: "blockquote",
      content: [
        {
          type: "paragraph",
          content: [
            {
              type: "text",
              text: expected
            }
          ]
        }
      ]
    }

    actual = render_inline class_name::Blockquote.new(node_content: content)

    assert_equal 1, actual.children.size
    assert_equal "blockquote", actual.children.first.name

    paragraph_element = actual.children.first.children.first
    assert_equal "p", paragraph_element.name
    assert_equal expected, actual.text
  end

  test "codeBlock: renders a multiline code block" do
    expected = "Code snippet \n  \t  Extra content in the code\nMore inline code\nMulti-line"
    node = {
      type: "codeBlock",
      attrs: {
        language: nil
      },
      content: [
        {
          type: "text",
          text: expected
        }
      ]
    }

    actual = render_inline class_name::CodeBlock.new(node_content: node)

    assert_equal 1, actual.children.size

    pre_element = actual.children.first
    assert_equal "pre", pre_element.name

    assert_equal 1, pre_element.children.size
    code_element = pre_element.children.first
    assert_equal "code", code_element.name

    assert_equal expected, actual.text
  end

  test "bulletList: renders an unordered list" do
    item_text_1 = Faker::Quotes::Chiquito.sentence
    item_text_2 = Faker::Quotes::Chiquito.sentence

    expected = [item_text_1, item_text_2].join

    node = {
      type: "bulletList",
      content: [
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_1
                }
              ]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_2
                }
              ]
            }
          ]
        }
      ]
    }

    actual = render_inline class_name::UnorderedList.new(node_content: node)

    assert_equal 1, actual.children.size

    list_element = actual.children.first
    assert_equal "ul", list_element.name

    assert_equal 2, list_element.children.size

    item_1_element = list_element.children[0]
    assert_equal "li", item_1_element.name
    assert_equal item_text_1, item_1_element.text

    item_2_element = list_element.children[1]
    assert_equal "li", item_2_element.name
    assert_equal item_text_2, item_2_element.text

    assert_equal expected, actual.text
  end

  test "bulletList: renders nested unordered lists" do
    item_text_1 = Faker::Quotes::Chiquito.sentence
    item_text_2 = Faker::Quotes::Chiquito.sentence
    item_text_3 = Faker::Quotes::Chiquito.sentence

    expected = [item_text_1, item_text_2, item_text_3].join

    node = {
      type: "bulletList",
      content: [
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_1
                }
              ]
            },
            {
              type: "bulletList",
              content: [
                {
                  type: "listItem",
                  content: [
                    {
                      type: "paragraph",
                      content: [
                        {
                          type: "text",
                          text: item_text_2
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_3
                }
              ]
            }
          ]
        }
      ]
    }

    actual = render_inline class_name::UnorderedList.new(node_content: node)

    assert_equal 1, actual.children.size

    list_element = actual.children.first
    assert_equal "ul", list_element.name

    assert_equal 2, list_element.children.size

    item_1_element = list_element.children[0]
    assert_equal "li", item_1_element.name

    assert_equal 2, item_1_element.children.size

    item_1_paragraph = item_1_element.children[0]
    assert_equal "p", item_1_paragraph.name
    assert_equal item_text_1, item_1_paragraph.text

    item_1_nested_list = item_1_element.children[1]
    assert_equal "ul", item_1_nested_list.name
    assert_equal 1, item_1_nested_list.children.size

    item_1_nested_list_item = item_1_nested_list.children.first
    assert_equal "li", item_1_nested_list_item.name
    assert_equal 1, item_1_nested_list_item.children.size

    item_1_nested_list_item_paragraph = item_1_nested_list_item.children.first
    assert_equal "p", item_1_nested_list_item_paragraph.name
    assert_equal item_text_2, item_1_nested_list_item_paragraph.text

    item_2_element = list_element.children[1]
    assert_equal "li", item_2_element.name
    assert_equal item_text_3, item_2_element.text

    assert_equal expected, actual.text
  end

  test "bulletList: renders an ordered list" do
    item_text_1 = Faker::Quotes::Chiquito.sentence
    item_text_2 = Faker::Quotes::Chiquito.sentence

    expected = [item_text_1, item_text_2].join

    node = {
      type: "orderedList",
      attrs: {
        start: 1
      },
      content: [
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_1
                }
              ]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_2
                }
              ]
            }
          ]
        }
      ]
    }

    actual = render_inline class_name::OrderedList.new(node_content: node)

    assert_equal 1, actual.children.size

    list_element = actual.children.first
    assert_equal "ol", list_element.name
    assert_equal "1", list_element.attributes["start"].value

    assert_equal 2, list_element.children.size

    item_1_element = list_element.children[0]
    assert_equal "li", item_1_element.name
    assert_equal item_text_1, item_1_element.text

    item_2_element = list_element.children[1]
    assert_equal "li", item_2_element.name
    assert_equal item_text_2, item_2_element.text

    assert_equal expected, actual.text
  end

  test "orderedList: renders nested ordered lists" do
    item_text_1 = Faker::Quotes::Chiquito.sentence
    item_text_2 = Faker::Quotes::Chiquito.sentence
    item_text_3 = Faker::Quotes::Chiquito.sentence

    expected = [item_text_1, item_text_2, item_text_3].join

    node = {
      type: "orderedList",
      attrs: {
        start: 1
      },
      content: [
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_1
                }
              ]
            },
            {
              type: "orderedList",
              attrs: {
                start: 2
              },
              content: [
                {
                  type: "listItem",
                  content: [
                    {
                      type: "paragraph",
                      content: [
                        {
                          type: "text",
                          text: item_text_2
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          type: "listItem",
          content: [
            {
              type: "paragraph",
              content: [
                {
                  type: "text",
                  text: item_text_3
                }
              ]
            }
          ]
        }
      ]
    }

    actual = render_inline class_name::OrderedList.new(node_content: node)

    assert_equal 1, actual.children.size

    list_element = actual.children.first
    assert_equal "ol", list_element.name
    assert_equal "1", list_element.attributes["start"].value

    assert_equal 2, list_element.children.size

    item_1_element = list_element.children[0]
    assert_equal "li", item_1_element.name

    assert_equal 2, item_1_element.children.size

    item_1_paragraph = item_1_element.children[0]
    assert_equal "p", item_1_paragraph.name
    assert_equal item_text_1, item_1_paragraph.text

    item_1_nested_list = item_1_element.children[1]
    assert_equal "ol", item_1_nested_list.name
    assert_equal "2", item_1_nested_list.attributes["start"].value
    assert_equal 1, item_1_nested_list.children.size

    item_1_nested_list_item = item_1_nested_list.children.first
    assert_equal "li", item_1_nested_list_item.name
    assert_equal 1, item_1_nested_list_item.children.size

    item_1_nested_list_item_paragraph = item_1_nested_list_item.children.first
    assert_equal "p", item_1_nested_list_item_paragraph.name
    assert_equal item_text_2, item_1_nested_list_item_paragraph.text

    item_2_element = list_element.children[1]
    assert_equal "li", item_2_element.name
    assert_equal item_text_3, item_2_element.text

    assert_equal expected, actual.text
  end


  test "renders an image attachment with a caption that has marks" do
    word_1 = "#{Faker::Lorem.word} "
    word_2 = Faker::Lorem.word
    word_3 = " #{Faker::Lorem.word}"

    expected_caption = [word_1, word_2, word_3].join

    attachment = Organization::Attachment.create!(
      attachment: image_file,
      organization: organizations.organization_1,
      user: users.organization_1_department_head,
    )

    attachment_url = attachment.attachment_url

    node = {
      type: "attachment-figure",
      attrs: {
        sgid: attachment.sgid_for_document,
        previewable: true,
        width: 420,
        height: 240
      },
      content: [
        {
          type: "text",
          text: word_1
        },
        {
          type: "text",
          marks: [{type: "bold"}],
          text: word_2
        },
        {
          type: "text",
          text: word_3
        },
      ]
    }

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 3, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal 1, div_container.children.size

    image_element = div_container.children.first
    assert_equal "img", image_element.name
    assert_equal attachment_url, image_element.attributes["src"].value
    assert_equal "420", image_element.attributes["width"].value
    assert_equal "240", image_element.attributes["height"].value

    attachment_details_element = figure_element.children[1]
    assert_equal "section", attachment_details_element.name
    assert_equal "attachment-details", attachment_details_element.attributes["class"].value

    assert_equal 1, attachment_details_element.children.size
    assert_equal "p", attachment_details_element.children[0].name

    link_element = attachment_details_element.children[0].children.first
    assert_equal "a", link_element.name
    assert_equal attachment_url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value

    assert_equal "dog.jpeg – 98.2 KB", link_element.text

    figcaption_element = figure_element.children[2]
    assert_equal "figcaption", figcaption_element.name

    assert_equal 3, figcaption_element.children.size
    assert_equal "text", figcaption_element.children[0].name
    assert_equal "strong", figcaption_element.children[1].name
    assert_equal "text", figcaption_element.children[2].name

    assert_equal expected_caption, figcaption_element.text
  end

  test "renders an image attachment without a caption" do
    attachment = Organization::Attachment.create!(
      attachment: image_file,
      organization: organizations.organization_1,
      user: users.organization_1_department_head,
    )

    attachment_url = attachment.attachment_url

    node = {
      type: "attachment-figure",
      attrs: {
        sgid: attachment.sgid_for_document,
        previewable: true,
        width: 420,
        height: 240
      },
    }

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 2, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal 1, div_container.children.size

    image_element = div_container.children.first
    assert_equal "img", image_element.name
    assert_equal attachment_url, image_element.attributes["src"].value
    assert_equal "420", image_element.attributes["width"].value
    assert_equal "240", image_element.attributes["height"].value

    attachment_details_element = figure_element.children[1]
    assert_equal "section", attachment_details_element.name
    assert_equal "attachment-details", attachment_details_element.attributes["class"].value

    assert_equal 1, attachment_details_element.children.size
    assert_equal "p", attachment_details_element.children[0].name

    link_element = attachment_details_element.children[0].children.first
    assert_equal "a", link_element.name
    assert_equal attachment_url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value

    assert_equal "dog.jpeg – 98.2 KB", link_element.text
  end

  test "renders a file attachment with a caption" do
    word_1 = "#{Faker::Lorem.word} "
    word_2 = Faker::Lorem.word
    word_3 = " #{Faker::Lorem.word}"

    expected_caption = [word_1, word_2, word_3].join

    attachment = Organization::Attachment.create!(
      attachment: csv_file,
      organization: organizations.organization_1,
      user: users.organization_1_department_head,
    )

    attachment_url = attachment.attachment_url

    expected_icon = render_inline PracticalViews::IconForFileExtensionComponent.new(extension: "csv")

    node = {
      type: "attachment-figure",
      attrs: {
        sgid: attachment.sgid_for_document,
        previewable: false,
      },
      content: [
        {
          type: "text",
          text: word_1
        },
        {
          type: "text",
          marks: [{type: "bold"}],
          text: word_2
        },
        {
          type: "text",
          text: word_3
        },
      ]
    }

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 3, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal expected_icon.to_html, div_container.children.to_html

    attachment_details_element = figure_element.children[1]
    assert_equal "section", attachment_details_element.name
    assert_equal "attachment-details", attachment_details_element.attributes["class"].value

    assert_equal 1, attachment_details_element.children.size
    assert_equal "p", attachment_details_element.children[0].name

    link_element = attachment_details_element.children[0].children.first
    assert_equal "a", link_element.name
    assert_equal attachment_url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value

    assert_equal "example.csv – 651 Bytes", link_element.text

    figcaption_element = figure_element.children[2]
    assert_equal "figcaption", figcaption_element.name

    assert_equal 3, figcaption_element.children.size
    assert_equal "text", figcaption_element.children[0].name
    assert_equal "strong", figcaption_element.children[1].name
    assert_equal "text", figcaption_element.children[2].name

    assert_equal expected_caption, figcaption_element.text
  end

  test "renders a file attachment without a caption" do
    attachment = Organization::Attachment.create!(
      attachment: csv_file,
      organization: organizations.organization_1,
      user: users.organization_1_department_head,
    )

    attachment_url = attachment.attachment_url

    expected_icon = render_inline PracticalViews::IconForFileExtensionComponent.new(extension: "csv")

    node = {
      type: "attachment-figure",
      attrs: {
        sgid: attachment.sgid_for_document,
        previewable: false,
      },
    }

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 2, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal expected_icon.to_html, div_container.children.to_html

    attachment_details_element = figure_element.children[1]
    assert_equal "section", attachment_details_element.name
    assert_equal "attachment-details", attachment_details_element.attributes["class"].value

    assert_equal 1, attachment_details_element.children.size
    assert_equal "p", attachment_details_element.children[0].name

    link_element = attachment_details_element.children[0].children.first
    assert_equal "a", link_element.name
    assert_equal attachment_url, link_element.attributes["href"].value
    assert_equal "_blank", link_element.attributes["target"].value

    assert_equal "example.csv – 651 Bytes", link_element.text
  end

  test "renders a figure with the missing file figure (no caption)" do
    node = {
      type: "attachment-figure",
      attrs: {
        sgid: SecureRandom.hex,
      },
    }

    expected_icon = render_inline PracticalViews::IconForFileExtensionComponent.new(extension: "missing")

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 2, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal expected_icon.to_html, div_container.children.to_html

    figcaption_element = figure_element.children[1]
    assert_equal "section", figcaption_element.name
    assert_equal 1, figcaption_element.children.size
    assert_equal "p", figcaption_element.children.first.name
    assert_equal I18n.t("tiptap_document.attachment_missing.text"), figcaption_element.text
  end

  test "renders a figure with the missing file figure (caption with marks)" do
    word_1 = "#{Faker::Lorem.word} "
    word_2 = Faker::Lorem.word
    word_3 = " #{Faker::Lorem.word}"

    expected_caption = [word_1, word_2, word_3].join

    node = {
      type: "attachment-figure",
      attrs: {
        sgid: SecureRandom.hex,
      },
      content: [
        {
          type: "text",
          text: word_1
        },
        {
          type: "text",
          marks: [{type: "bold"}],
          text: word_2
        },
        {
          type: "text",
          text: word_3
        },
      ]
    }

    expected_icon = render_inline PracticalViews::IconForFileExtensionComponent.new(extension: "missing")

    actual = render_inline class_name::Attachment.new(node_content: node)

    assert_equal 1, actual.children.size
    figure_element = actual.children.first
    assert_equal "figure", figure_element.name
    assert_equal "wa-stack wa-gap-s", figure_element.attributes["class"].value

    assert_equal 3, figure_element.children.size

    div_container = figure_element.children[0]
    assert_equal "div", div_container.name
    assert_equal expected_icon.to_html, div_container.children.to_html

    figcaption_element = figure_element.children[1]
    assert_equal "section", figcaption_element.name
    assert_equal 1, figcaption_element.children.size
    assert_equal "p", figcaption_element.children.first.name
    assert_equal I18n.t("tiptap_document.attachment_missing.text"), figcaption_element.text

    figcaption_element = figure_element.children[2]
    assert_equal "figcaption", figcaption_element.name

    assert_equal 3, figcaption_element.children.size
    assert_equal "text", figcaption_element.children[0].name
    assert_equal "strong", figcaption_element.children[1].name
    assert_equal "text", figcaption_element.children[2].name

    assert_equal expected_caption, figcaption_element.text
  end
end
