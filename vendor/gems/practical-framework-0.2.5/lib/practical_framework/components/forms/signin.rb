# frozen_string_literal: true

class PracticalFramework::Components::Forms::Signin < Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::T
  include PracticalFramework::Railtie::PracticalFrameworkFormBuilderActiveSupportExtension

  attr_accessor :model, :as, :url, :challenge_url, :credential_field_name, :builder, :form_id, :generic_errors_id

  def self.default_builder_class
    PracticalFramework::FormBuilders::Base
  end

  def initialize(model:, as:, url:, challenge_url:, credential_field_name:, builder: self.class.default_builder_class)
    self.model = model
    self.as = as
    self.url = url
    self.challenge_url = challenge_url
    self.credential_field_name = credential_field_name
    self.builder = builder
  end

  def view_template
    self.form_id = dom_id(model, :session_form)
    self.generic_errors_id = dom_id(model, :generic_errors)

    practical_form_with("model": model,
                        "as": as,
                        "url": url,
                        "local": false,
                        "id": form_id,
                        "aria-describedby": generic_errors_id,
                        "data": {
                          type: :json,
                          challenge_url: challenge_url,
                          credential_field_name: credential_field_name
                        }, "builder": PracticalFramework::FormBuilders::Base,
                        "class": "stack-compact",
    ) do |f|
      f.fieldset do
        f.legend do
          unsafe_raw(helpers.signin_icon)
          whitespace
          plain t("signin.form.title")
        end

        f.input_wrapper do
          f.label :email do
            icon(style: 'fa-solid', name: 'at')
            plain "Email"
          end

          f.email_field(:email, placeholder: t("practical_framework.forms.placeholders.email"),
                                autofocus: true,
                                autocomplete: "username webauthn",
                                required: false,
                                data: {"focusout-validation": true}
                       )

          f.field_errors :email
        end

        f.fallback_error_section(options: {id: generic_errors_id })
        f.hidden_field :passkey_credential

        section {
          submit_button
        }
      end
    end
  end

  def submit_button
    icon = capture{ helpers.passkey_icon }
    render PracticalFramework::Components::StandardButton.new(title: "Sign in",
                                                              leading_icon: icon,
                                                              type: :submit,
                                                              html_options: {data: {disable: true}}
                                                            )
  end
end