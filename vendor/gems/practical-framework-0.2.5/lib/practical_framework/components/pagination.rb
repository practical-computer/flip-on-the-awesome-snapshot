# frozen_string_literal: true

class PracticalFramework::Components::Pagination < Phlex::HTML
  include Pagy::Frontend
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::HiddenFieldTag
  attr_reader :request
  attr_accessor :pagy, :item_name, :i18n_key

  def initialize(pagy:, request:, item_name: nil, i18n_key: nil)
    self.pagy = pagy
    self.item_name = item_name
    self.i18n_key = i18n_key
    @request = request
  end

  def view_template
    nav(class: 'stack-compact pagination') {
      p { page_detail_text }
      if pagy.pages > 4
        goto_page_form
      end

      section(class: "cluster-default", role: :list){
        previous_item

        pagy.series.each do |item|
          page_item(item)
        end

        next_item
      }
    }
  end

  def goto_page_form
    uri = URI.parse(pagy_url_for(pagy, nil))
    params = Rack::Utils.parse_query(uri.query)
    params.delete("page")
    uri.query = ""

    form_with(url: uri.to_s, method: :get, local: true, builder: PracticalFramework::FormBuilders::Base) do |f|
      params.each do |key, value|
        hidden_field_for_goto_form(key: key, value: value)
      end

      f.fieldset(class: "inline-size-fit-content box-extra-compact",
                 remove_classes: ["stack-compact", "box-compact"]) do
        f.legend do
          pagy_t("pagy.nav.goto_page_form.legend")
        end

        div{
          f.number_field :page, value: pagy.page, placeholder: pagy.page.to_s, required: true, min: 1, max: pagy.last
          whitespace
          render PracticalFramework::Components::StandardButton.new(type: :submit,
                                                                    title: pagy_t("pagy.nav.goto_page_form.button"),
                                                                    leading_icon: nil)
        }
      end
    end
  end

  def hidden_field_for_goto_form(key:, value:)
    case value
    when Array
      value.each do |x|
        hidden_field_tag key, x
      end
    else
      hidden_field_tag key, value
    end
  end

  def page_detail_text
    pagy_count = pagy.count
    if pagy_count == 0
      key = "pagy.info.no_items"
    elsif pagy.pages == 1
      key = "pagy.info.single_page"
    else
      key = "pagy.info.multiple_pages"
    end

    item_name = item_name.presence || pagy_t(i18n_key || pagy.vars[:i18n_key], count: pagy_count)

    item_text = pagy_t(key,
                       item_name: item_name,
                       count: pagy_count, from: pagy.from, to: pagy.to
    )

    page_count_text = pagy_t("pagy.info.page_count", page: pagy.page, count: pagy.pages)

    return pagy_t("pagy.info.page_detail_text", item_text: item_text, page_count_text: page_count_text)
  end

  def previous_item
    classes = tokens(:page, :previous, -> { !pagy.prev } => :disabled)

    text = pagy_t('pagy.nav.prev', icon: capture {icon(style: "fa-solid", name: "arrow-left")})

    div(class: classes, role: :listitem){
      if pagy.prev
        a(href: pagy_url_for(pagy, pagy.prev), title: pagy_t("pagy.nav.prev_page_title")) { unsafe_raw(text) }
      else
        unsafe_raw(text)
      end
    }
  end

  def next_item
    classes = tokens(:page, :next, -> { !pagy.next } => :disabled)

    text = pagy_t('pagy.nav.next', icon: capture {icon(style: "fa-solid", name: "arrow-right")})

    div(class: classes, role: :listitem){
      if pagy.next
        a(href: pagy_url_for(pagy, pagy.next), title: pagy_t("pagy.nav.next_page_title")) { unsafe_raw(text) }
      else
        unsafe_raw(text)
      end
    }
  end

  def page_item(item)
    case item
    when Integer
      div(class: tokens(:page), role: :listitem) {
        a(href: pagy_url_for(pagy, item), title: pagy_t("pagy.nav.page_title", page_number: item)){ item }
      }
    when String
      div(class: tokens(:page, :current), role: :listitem,
          title: pagy_t("pagy.nav.current_page_title", page_number: item)
      ) { item }
    when :gap
      div("class": tokens(:page, :gap), "role": :listitem, "aria-hidden": true) { unsafe_raw(pagy_t('pagy.nav.gap')) }
    end
  end
end
