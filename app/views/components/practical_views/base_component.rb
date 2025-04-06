# frozen_string_literal: true

class PracticalViews::BaseComponent < ViewComponent::Base
  include PracticalViews::ElementHelper
  delegate :safe_join, to: :helpers
end
