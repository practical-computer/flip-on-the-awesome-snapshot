# frozen_string_literal: true

module PracticalFramework::Controllers::JSONRedirection
  def json_redirect(location:)
    render json: {location: location}, status: 322
  end
end