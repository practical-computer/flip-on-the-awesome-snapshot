# frozen_string_literal: true

class ApplicationComponent < PracticalViews::BaseComponent
  delegate :icon_set, :icon_text, :current_organization, to: :helpers
end
