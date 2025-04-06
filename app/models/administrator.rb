# frozen_string_literal: true

class Administrator < ApplicationRecord
  devise :passkey_authenticatable, :rememberable

  has_many :passkeys, class_name: "Administrator::Passkey", dependent: :destroy
  has_many :emergency_passkey_registrations, dependent: :destroy

  normalizes :email, with: ->(email){ email.strip.downcase }
  validates :webauthn_id, presence: true, allow_blank: false, uniqueness: true
  validates :email, presence: true, allow_blank: false, uniqueness: true

  def self.passkeys_class
    Administrator::Passkey
  end

  def self.find_for_passkey(passkey)
    self.find_by(id: passkey.administrator.id)
  end

  def after_passkey_authentication(passkey:)
  end

  def rememberable_options
    super.merge(domain: [AppSettings.default_host])
  end
end
