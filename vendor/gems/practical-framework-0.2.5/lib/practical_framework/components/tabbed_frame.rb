# frozen_string_literal: true

class PracticalFramework::Components::TabbedFrame < Phlex::HTML
  attr_accessor :sections, :panels, :use_seven_minute_tabs
  register_element :seven_minute_tabs

  def initialize(sections:, panels:, use_seven_minute_tabs: true)
    self.sections = sections
    self.panels = panels
    self.use_seven_minute_tabs = use_seven_minute_tabs
  end

  def view_template
    if use_seven_minute_tabs
      seven_minute_tabs {
        tab_contents
      }
    else
      tab_contents
    end
  end

  def tab_contents
    contents_container(**frame_classes) {
      nav(**nav_classes) {
        self.sections.each do |section|
          render section
        end
      }

      section(**frame_content_classes){
        self.panels.each do |panel|
          render panel
        end
      }
    }
  end

  def contents_container(**args, &block)
    section(**args, &block)
  end

  def frame_classes
    classes(:"tabbed-frame", :"box-compact", :rounded, :"with-sidebar")
  end

  def frame_content_classes
    classes(:"tabbed-frame-content", :"box-compact")
  end

  def nav_classes
    classes(:"stack-default")
  end

  class NavigationSection < Phlex::HTML
    include Phlex::DeferredRender

    def initialize
      @items = []
    end

    def view_template(&block)
      section(**classes(:rounded, :"box-extra-compact", :"stack-compact"), role: :tablist) do
        if @title
          render @title
        end

        @items.each do |item|
          render item
        end
      end
    end

    def title(&block)
      @title = block
    end

    def with_item(&block)
      @items << block
    end
  end

  class NavigationLink < Phlex::HTML
    attr_accessor :href, :selected

    def initialize(href:, selected: false)
      self.href = href
      self.selected = selected
    end

    def view_template(&content_block)
      options = {
        "href": href,
        "role": :tab,
        "aria-selected": selected.to_s,
        **classes(:"cluster-compact")
      }

      a(**options, &content_block)
    end
  end

  class Panel < Phlex::HTML
    attr_accessor :panel_id

    def initialize(panel_id:)
      self.panel_id = panel_id
    end

    def view_template
      section(id: panel_id, role: :tabpanel) do
        render @block_content
      end
    end

    def content(&block)
      @block_content = block
    end
  end
end
