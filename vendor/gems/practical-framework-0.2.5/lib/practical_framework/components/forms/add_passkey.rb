# frozen_string_literal: true

class PracticalFramework::Components::Forms::AddPasskey < Phlex::HTML
  include FontAwesomeHelpers::ViewHelpers
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FieldName
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::T
  include PracticalFramework::Railtie::PracticalFrameworkFormBuilderActiveSupportExtension

  attr_accessor :scope, :url, :form_id, :new_passkey_fields_id, :unlock_button_id, :reauthentication_challenge_url,
                :reauthentication_token_url,
                :challenge_url,
                :builder,
                :generic_errors_id

  def initialize(scope:, url:, form_id:, new_passkey_fields_id:,
                 unlock_button_id:, reauthentication_challenge_url:,
                 reauthentication_token_url:, challenge_url:, builder: PracticalFramework::FormBuilders::Base
  )
    self.scope = scope
    self.url = url
    self.form_id = form_id
    self.new_passkey_fields_id = new_passkey_fields_id
    self.unlock_button_id = unlock_button_id
    self.reauthentication_challenge_url = reauthentication_challenge_url
    self.reauthentication_token_url = reauthentication_token_url
    self.challenge_url = challenge_url
    self.builder = builder
  end

  def view_template
    self.generic_errors_id = [form_id, :generic_errors].map(&:to_s).join("-")

    practical_form_with(
      "scope": scope,
      "url": url,
      "local": false,
      "id": form_id,
      "aria-describedby": generic_errors_id,
      "data": {
        type: :json,
        reauthentication_challenge_url: reauthentication_challenge_url,
        reauthentication_token_url: reauthentication_token_url,
        reauthentication_token_field_name:  field_name(scope, :reauthentication_token),
        challenge_url: challenge_url,
        credential_field_name: field_name(scope, :credential)
      },
      "builder": PracticalFramework::FormBuilders::Base,
      "class": "stack-compact",
    ) do |f|
      f.fieldset do
        form_legend(f)

        section do
          unlock_button
          f.hidden_field :reauthentication_token
        end

        f.fieldset(id: new_passkey_fields_id, disabled: true) do
          passkey_label_input(f)
          f.hidden_field :credential
          section{ submit_button }
        end
      end
    end
  end

  def form_legend(f)
    f.legend do
      unsafe_raw(helpers.passkey_icon)
      whitespace
      plain t("user_settings.passkeys.create.form.title")
    end
  end

  def passkey_label_input(f)
    f.input_wrapper do
      f.label :label do
        icon(style: 'fa-solid', name: 'tag')
        whitespace
        plain "Passkey label"
      end

      f.text_field(:label, placeholder: t("practical_framework.forms.placeholders.passkey_label"),
                            autofocus: "off",
                            required: true,
                            data: {"focusout-validation": true}
                  )

      f.field_errors :label
    end
  end

  def unlock_button
    icon = capture{ helpers.passkey_icon }
    render PracticalFramework::Components::StandardButton.new(title: t("practical_framework.forms.unlock_title"),
                                                              leading_icon: icon,
                                                              type: :button,
                                                              html_options: {id: unlock_button_id}
                                                              )
  end

  def submit_button
    icon = capture{ helpers.passkey_icon }
    title = t("user_settings.passkeys.create.form.submit_button_title")
    render PracticalFramework::Components::StandardButton.new(title: title,
                                                              leading_icon: icon,
                                                              type: :submit,
                                                              html_options: {data: {disable: true}}
                                                            )
  end
end