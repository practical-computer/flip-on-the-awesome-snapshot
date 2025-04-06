# frozen_string_literal: true

Rails.application.config.dartsass.builds = {
  "framework.scss"  => "practical-framework.css",
  "fontawesome.scss"  => "fontawesome.css",
  "application.scss"  => "application.css",
  "web-awesome.scss"  => "web-awesome.css",
  "v2-framework.scss"  => "v2-framework.css",
}

Rails.application.config.dartsass.build_options = [" --load-path ./node_modules/"]
