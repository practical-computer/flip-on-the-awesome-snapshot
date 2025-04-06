# frozen_string_literal: true

module PracticalFramework::TestHelpers::AdministratorTestHelpers
  def switch_to_admin_host
    host!(AppSettings.generate_uri(subdomain: "admin"))
  end
end
