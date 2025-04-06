# frozen_string_literal: true

module PracticalFramework::TestHelpers::FakerSeedPinning
  def before_setup
    super
    Faker::Config.random = Random.new(Minitest.seed)
  end
end