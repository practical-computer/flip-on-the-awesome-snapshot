# frozen_string_literal: true

class WebManifestController < ActionController::Base
  def manifest
    render json: manifest_hash
  end

  def admin_manifest
    render json: admin_manifest_hash
  end

  def admin_manifest_hash
    {
      icons: [
        { src: helpers.image_url("icons/icon-192-admin.png"), type: "image/png", sizes: "192x192" },
        { src: helpers.image_url("icons/icon-192-admin.png"), type: "image/png", sizes: "512x512" }
      ]
    }
  end

  def manifest_hash
    {
      icons: [
        { src: helpers.image_url("icons/icon-192.png"), type: "image/png", sizes: "192x192" },
        { src: helpers.image_url("icons/icon-192.png"), type: "image/png", sizes: "512x512" }
      ]
    }
  end
end
