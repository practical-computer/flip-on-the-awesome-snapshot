# frozen_string_literal: true

class Utility::IPAddress < ApplicationRecord
  validates :address, presence: true, allow_blank: false, uniqueness: true

  def self.upsert_address(address:)
    upsert({address: address}, returning: [:id], unique_by: :address)
    find_by(address: address)
  end
end
