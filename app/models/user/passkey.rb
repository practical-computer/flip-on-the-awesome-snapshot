# frozen_string_literal: true

class User::Passkey < ApplicationRecord
  belongs_to :user
  belongs_to :emergency_passkey_registration, optional: true

  validates :label, presence: true, allow_blank: false, uniqueness: {scope: :user_id}
  validates :external_id, presence: true, allow_blank: false, uniqueness: true
  validates :public_key, presence: true, allow_blank: false, uniqueness: true
end
