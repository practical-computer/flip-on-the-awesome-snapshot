# frozen_string_literal: true

class Oaken::TestCaseGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def generate
    template "test_case.rb", "db/seeds/test/cases/#{file_name}.rb"
  end
end
