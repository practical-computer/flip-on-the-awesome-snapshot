# frozen_string_literal: true

class PracticalFramework::Components::TiptapDocument < Phlex::HTML
  class UnknownNodeTypeError < StandardError; end
  class UnknownMarkupTypeError < StandardError; end

  module NodeRendering
    def render_node(node:)
      case node[:type].to_sym
      when :text
        render Text.new(content: node)
      when :paragraph
        render Paragraph.new(content: node)
      when :heading
        render Heading.new(content: node)
      when :codeBlock
        render CodeBlock.new(content: node)
      when :listItem
        render ListItem.new(content: node)
      when :bulletList
        render UnorderedList.new(content: node)
      when :orderedList
        render OrderedList.new(content: node)
      when :"attachment-figure", :"previewable-attachment-figure"
        render Attachment.new(content: node)
      when :blockquote
        render Blockquote.new(content: node)
      else
        raise UnknownNodeTypeError
      end
    end
  end

  include NodeRendering

  attr_reader :document

  def initialize(document:)
    raise ArgumentError if document["type"] != "doc"
    @document = document.with_indifferent_access
  end

  def view_template
    document[:content].each do |node|
      render_node(node: node)
    end
  end

  class Node < Phlex::HTML
    include NodeRendering

    attr_reader :content

    def initialize(content:)
      @content = content
    end
  end

  class Text < Node
    SORTED_MARKUP_TYPES = [
      "rhino-strike", "link", "bold", "italic"
    ].freeze

    def applicable_markup_types
      SORTED_MARKUP_TYPES.select{|type| content[:marks].any?{ |mark| mark[:type] == type }}
    end

    def view_template
      if content[:marks].present? && content[:marks].any?
        render_with_marks(markup_to_apply: applicable_markup_types)
      else
        render_plaintext
      end
    end

    def render_with_marks(markup_to_apply:)
      markup_type = markup_to_apply.shift
      case markup_type
      when "italic"
        em{ render_with_marks(markup_to_apply: markup_to_apply) }
      when "bold"
        strong { render_with_marks(markup_to_apply: markup_to_apply) }
      when "rhino-strike"
        del { render_with_marks(markup_to_apply: markup_to_apply) }
      when "link"
        a(**link_attributes) { render_with_marks(markup_to_apply: markup_to_apply) }
      when nil
        render_plaintext
      else
        raise UnknownMarkupTypeError
      end
    end

    def link_attributes
      content[:marks]&.find{|mark| mark[:type] == "link" }&.dig(:attrs)&.slice(:href, :target, :rel).to_h
    end

    def render_plaintext
      plain(content[:text])
    end
  end

  class Paragraph < Node
    def view_template
      p {
        if content[:content].present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end
  end

  class Heading < Node
    def view_template
      heading_element {
        if content.present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end

    def heading_element(&block)
      case content.dig(:attrs, :level)
      when 1
        h1(&block)
      when 2
        h2(&block)
      when 3
        h3(&block)
      when 4
        h4(&block)
      when 5
        h5(&block)
      when 6
        h6(&block)
      end
    end
  end

  class Blockquote < Node
    def view_template
      blockquote {
        if content[:content].present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end
  end

  class CodeBlock < Node
    def view_template
      pre {
        if content[:content].present?
          code { content[:content].each{|node| render_node(node: node)} }
        end
      }
    end
  end

  class ListItem < Node
    def view_template
      li {
        if content.present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end
  end

  class UnorderedList < Node
    def view_template
      ul {
        if content.present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end
  end

  class OrderedList < Node
    def view_template
      ol(start: content.dig(:attrs, :start)) {
        if content.present?
          content[:content].each{|node| render_node(node: node)}
        end
      }
    end
  end

  class Attachment < Node
    include Phlex::Rails::Helpers::T

    def view_template
      figure(class: 'stack-compact') {
        if missing_attachment?
          missing_attachment_figure
        else
          attachment_figure
        end
      }
    end

    def missing_attachment_figure
      div {
        render PracticalFramework::Components::IconForFileExtension.new(extension: "missing")
      }

      section(class: 'attachment-details') {
        p {
          plain(t("tiptap_document.attachment_missing.text"))
        }
      }

      figure_caption
    end

    def attachment_figure
      if previewable?
        div {
          img(src: url, width: width, height: height)
        }
      else
        div {
          render PracticalFramework::Components::IconForFileExtension.new(extension: extension)
        }
      end

      attachment_details_and_download

      figure_caption
    end

    def figure_caption
      if content[:content].present?
        figcaption { content[:content].each{|node| render_node(node: node)} }
      end
    end

    def attachment_details_and_download
      section(class: 'attachment-details') {
        p {
          a(href: url, target: "_blank") {
            plain("#{filename} – #{human_file_size}")
          }
        }
      }
    end

    def attachment
      @attachment ||= GlobalID::Locator.locate_signed(sgid.to_s, for: :document)&.attachment
    end

    def missing_attachment?
      attachment.nil?
    end

    def attrs
      content[:attrs]
    end

    def previewable?
      attrs.dig(:previewable)
    end

    def sgid
      attrs.dig(:sgid)
    end

    def filename
      attachment.original_filename
    end

    def human_file_size
      helpers.number_to_human_size(attachment.size)
    end

    def url
      attachment.url
    end

    def extension
      attachment.extension
    end

    def stored_width
      attrs.dig(:width)
    end

    def stored_height
      attrs.dig(:height)
    end

    def has_dimensions?
      !stored_width.blank? && !stored_height.blank?
    end

    def width
      return stored_width if has_dimensions?
      default_figure_size
    end

    def height
      return stored_height if has_dimensions?
      default_figure_size
    end

    def default_figure_size
      100
    end
  end
end