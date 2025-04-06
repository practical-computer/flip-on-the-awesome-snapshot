# frozen_string_literal: true

require 'oaken'

module Oaken
  class Railtie < Rails::Railtie
    initializer "oaken.set_fixture_replacement" do
      GeneratorConfiguration.run(config)
    end
  end

  class GeneratorConfiguration
    def self.run(config)
      test_framework = config.app_generators.options[:rails][:test_framework]

      config.app_generators.test_framework(
        test_framework,
        fixture: false,
        fixture_replacement: :oaken
      )
    end
  end
end
