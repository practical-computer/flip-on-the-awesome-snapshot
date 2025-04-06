# frozen_string_literal: true

class Readonly::OnsitesController < Readonly::BaseController
  before_action :load_readonly_onsite

  def show
  end

  private

  def load_readonly_onsite
    @onsite = Organization::Onsite.find_by_token_for!(:readonly_view, params[:id])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    raise ActiveRecord::RecordNotFound
  end
end
