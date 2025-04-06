# frozen_string_literal: true

require 'rails/generators/active_record'

class Devise::Passkeys::WebAuthnMigrationGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def migration_to_add_webauthn_id_to_resource
    migration_template "migration.rb", "db/migrate/add_webauthn_id_to_#{table_name}.rb"
  end

  protected

  def migration_version
    "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
  end
end
