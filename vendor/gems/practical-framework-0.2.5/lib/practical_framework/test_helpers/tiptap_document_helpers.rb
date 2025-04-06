# frozen_string_literal: true

module PracticalFramework::TestHelpers::TiptapDocumentHelpers
  def example_tiptap_document(sentence: "Here's some new content")
    return {
      type: "doc",
      content: [
        {
          type: "heading",
          attrs: {
            level: 1
          },
          content: [
            {
              type: "text",
              text: "A new note"
            }
          ]
        },
        {
          type: "paragraph",
          content: [
            {
              type: "text",
              text: sentence
            }
          ]
        }
      ]
    }
  end

  def example_quick_note(sentences:)
    paragraphs = sentences.map do |sentence|
      {
        type: "paragraph",
        content: [
          {
            type: "text",
            text: sentence
          }
        ]
      }
    end

    return {
      type: "doc",
      content: paragraphs
    }
  end
end