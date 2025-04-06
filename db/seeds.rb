# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'
require "practical_framework/test_helpers"
require 'practical_framework/test_helpers/tiptap_document_helpers'

Oaken.prepare do
  users.defaults(name: -> { Faker::Name.name },
                 email: -> { Faker::Internet.email },
                 webauthn_id: -> { SecureRandom.uuid }
                )

  def users.create_labeled(label, email: labeled_email(label), **)
    create(label, unique_by: :email, email: email, **)
  end

  def users.labeled_email(label)
    "#{label}@example.com"
  end

  def google_places.create_labeled(label, google_place_api_id:, **)
    create(label, unique_by: [:google_place_api_id], google_place_api_id: google_place_api_id, **)
  end

  seed :administrators, :users
  seed :organizations
  seed :google_places

  register Organization::Job
  register Organization::Onsite
  register Organization::JobTask

  section :organization_resources do
    def organization_jobs.create_labeled(label, name:, organization:, **)
      create(label, unique_by: [:name, :organization_id],
                    name: name,
                    organization: organization,
                    **
            )
    end

    def organization_onsites.create_labeled(label, job:, **)
      create(label, unique_by: [:label, :job_id], label: label, job: job, **)
    end

    def organization_job_tasks.create_labeled(label, job:, **)
      create(label, unique_by: [:label, :job_id], label: label, job: job, **)
    end

    seed :organization_jobs
  end
end
