thomas = users.create(:thomas, unique_by: :email, email: "thomas@example.com",
                         webauthn_id: SecureRandom.uuid
               )

if thomas.passkeys.empty?
  registration = thomas.emergency_passkey_registrations.create!
end
