# frozen_string_literal: true

class Organization::ResourceLocalizationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def add_localization_file
    template "localization.yml", File.join("config/locales/dispatcher/#{plural_name}.en.yml")
  end
end
