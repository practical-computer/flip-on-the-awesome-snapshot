# frozen_string_literal: true

class PracticalViews::PageComponent < PracticalViews::BaseComponent
  renders_one :banner
  renders_one :header
  renders_one :subheader
  renders_one :footer
  renders_one :main_header
  renders_one :navigation
  renders_one :navigation_header
  renders_one :navigation_footer
end
