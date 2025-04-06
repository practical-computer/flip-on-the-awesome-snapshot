# frozen_string_literal: true

class Devise::Passkeys::InstallGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def webauthn_id_migration_for_resource
    generate "devise:passkeys:web_authn_migration", name
  end

  def add_passkey_authenticatable_to_users
    gsub_file(model_path, /:database_authenticatable/, ":passkey_authenticatable")
  end

  def generate_passkey_model
    passkey_model_args = [
      "Passkey",
      "#{singular_name}:references",
      "label:string external_id:string:index:uniq public_key:string:index sign_count:integer last_used_at:datetime"
    ]
    generate "model", passkey_model_args
  end

  def add_required_passkey_code_to_resource
    inject_into_class model_path, class_name do
      <<-RUBY
        has_many :passkeys

        def self.passkeys_class
          Passkey
        end

        def self.find_for_passkey(passkey)
          self.find_by(id: passkey.#{singular_name}.id)
        end

        def after_passkey_authentication(passkey:)
        end
      RUBY
    end
  end

  def add_relying_party_concern
    template "relying_party_concern.rb", Rails.root.join("app/controllers/concerns/relying_party.rb")
  end

  def implement_passkey_authenticatable_module
    append_to_file model_path do
      <<~RUBY
      Devise.add_module :passkey_authenticatable,
                        model: 'devise/passkeys/model',
                        route: {session: [nil, :new, :create, :destroy] },
                        controller: 'controller/sessions',
                        strategy: true
      RUBY
    end
  end

  protected

  def model_path
    Rails.root.join("app/models/#{file_name}.rb")
  end
end
