# frozen_string_literal: true

class UserPolicy < ActionPolicy::Base
  default_rule :manage?

  def manage?
    record == user
  end
end