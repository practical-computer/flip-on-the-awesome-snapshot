# frozen_string_literal: true

class UserNameComponent < ApplicationComponent
  attr_accessor :user, :options
  delegate :name, to: :user

  def initialize(user:, options: {})
    self.user = user
    self.options = options
  end

  def call
    tag.span(**mix({class: ["wa-flank", "user-name"]}, options)) {
      helpers.safe_join([
        tag.wa_avatar(
          initials: helpers.initials(name: name),
          style: "--size: var(--wa-font-size-2xl)"
        ),
        tag.span(name)
      ])
    }
  end
end
