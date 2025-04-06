# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: AppSettings.support_email
end
