# frozen_string_literal: true

class Devise::Strategies::PasskeyAuthenticatable
  def user_verification_flag
    nil
  end
end