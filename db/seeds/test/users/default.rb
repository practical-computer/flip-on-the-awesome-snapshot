# frozen_string_literal: true

buffy = users.create(:buffy, email: Faker::Internet.email,
                             webauthn_id: SecureRandom.uuid,
                             name: Faker::Name.name
                    )

buffy.passkeys.create!(
  label: "Buffy Passkey",
  external_id: SecureRandom.hex,
  public_key: SecureRandom.hex
)


rosa = users.create(:rosa, email: Faker::Internet.email,
                           webauthn_id: SecureRandom.uuid,
                           name: Faker::Name.name
                   )

rosa.passkeys.create!(
  label: "Rosa Passkey",
  external_id: SecureRandom.hex,
  public_key: SecureRandom.hex
)


rosa.emergency_passkey_registrations.create!(
  utility_user_agent: Utility::UserAgent.upsert_user_agent(user_agent: Faker::Internet.user_agent),
  utility_ip_address: Utility::IPAddress.upsert_address(address: Faker::Internet.ip_v6_address),
)
