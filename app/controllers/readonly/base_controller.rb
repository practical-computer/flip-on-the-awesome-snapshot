# frozen_string_literal: true

class Readonly::BaseController < ApplicationController
  layout "app_chrome"
  skip_verify_authorized
end