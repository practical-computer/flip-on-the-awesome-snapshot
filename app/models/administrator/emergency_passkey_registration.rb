# frozen_string_literal: true

class Administrator::EmergencyPasskeyRegistration < ApplicationRecord
  class AlreadyUsedError < StandardError; end

  belongs_to :administrator
  belongs_to :passkey, optional: true, foreign_key: :administrator_passkey_id
  belongs_to :utility_user_agent, optional: true, class_name: "Utility::UserAgent"
  belongs_to :utility_ip_address, optional: true, class_name: "Utility::IPAddress"

  scope :available, -> { where(used_at: nil) }

  generates_token_for :emergency_registration, expires_in: 15.minutes do
    used_at&.iso8601
  end

  def use_for_and_notify!(new_passkey:)
    raise AlreadyUsedError if self.passkey.present? || self.used_at.present?

    self.update!(
      used_at: Time.now.utc,
      passkey: new_passkey
    )

    Administrator::PasskeyMailer.passkey_added(passkey: new_passkey).deliver_later
  end
end
