# frozen_string_literal: true

thomas = administrators.create(:thomas, unique_by: :email, email: "thomas@practical.computer",
                         webauthn_id: SecureRandom.uuid
               )

if thomas.passkeys.empty?
  registration = thomas.emergency_passkey_registrations.create!
end
