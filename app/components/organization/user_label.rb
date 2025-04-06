# frozen_string_literal: true

class Organization::UserLabel < Phlex::HTML
  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  def view_template
    span(class: 'user-label'){
      unsafe_raw helpers.user_icon
      whitespace
      plain(user.name)
    }
  end
end