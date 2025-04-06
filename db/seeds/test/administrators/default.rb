# frozen_string_literal: true

kira = administrators.create(:kira, email: "kira@example.com", webauthn_id: SecureRandom.hex)

dummy_passkey = kira.passkeys.create!(
  label: "Dummy Passkey",
  external_id: SecureRandom.hex,
  public_key: SecureRandom.hex
)

emergency_registration = kira.emergency_passkey_registrations.create!(
  utility_user_agent: Utility::UserAgent.upsert_user_agent(user_agent: Faker::Internet.user_agent),
  utility_ip_address: Utility::IPAddress.upsert_address(address: Faker::Internet.ip_v6_address),
)
