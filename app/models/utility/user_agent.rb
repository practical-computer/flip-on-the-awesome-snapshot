# frozen_string_literal: true

class Utility::UserAgent < ApplicationRecord
  validates :user_agent, presence: true, allow_blank: false, uniqueness: true

  def client
    @client ||= DeviceDetector.new(user_agent)
  end

  def self.upsert_user_agent(user_agent:)
    upsert({user_agent: user_agent}, returning: [:id], unique_by: :user_agent)
    find_by(user_agent: user_agent)
  end
end
