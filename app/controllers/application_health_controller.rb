# frozen_string_literal: true

class ApplicationHealthController < Rails::HealthController
  def db
    ActiveRecord::Base.establish_connection # Establishes connection
    ActiveRecord::Base.connection # Calls connection object
    if ActiveRecord::Base.connected?
      render_up
    else
      render_down
    end
  end

  def wafris
    if Wafris.configuration.redis.ping
      render_up
    else
      render_down
    end
  end
end