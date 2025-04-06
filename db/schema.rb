# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_02_204440) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "administrator_emergency_passkey_registrations", force: :cascade do |t|
    t.bigint "administrator_id", null: false
    t.bigint "administrator_passkey_id"
    t.bigint "utility_user_agent_id"
    t.bigint "utility_ip_address_id"
    t.timestamptz "used_at"
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.index ["administrator_id"], name: "idx_on_administrator_id_25d1e90c84"
    t.index ["administrator_passkey_id"], name: "idx_on_administrator_passkey_id_456953778b"
    t.index ["utility_ip_address_id"], name: "idx_on_utility_ip_address_id_075c36d56a"
    t.index ["utility_user_agent_id"], name: "idx_on_utility_user_agent_id_a91b9334a1"
  end

  create_table "administrator_passkeys", force: :cascade do |t|
    t.bigint "administrator_id", null: false
    t.string "label", null: false
    t.string "external_id", null: false
    t.string "public_key", null: false
    t.integer "sign_count"
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["administrator_id"], name: "index_administrator_passkeys_on_administrator_id"
    t.index ["external_id"], name: "index_administrator_passkeys_on_external_id", unique: true
    t.index ["public_key"], name: "index_administrator_passkeys_on_public_key", unique: true
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "webauthn_id"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "remember_token", default: -> { "gen_salt('bf'::text)" }
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_administrators_on_email", unique: true
    t.index ["remember_token"], name: "index_administrators_on_remember_token", unique: true
    t.index ["webauthn_id"], name: "index_administrators_on_webauthn_id", unique: true
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "google_places", force: :cascade do |t|
    t.string "google_place_api_id"
    t.string "human_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_place_api_id"], name: "index_google_places_on_google_place_api_id", unique: true
  end

  create_table "membership_invitations", force: :cascade do |t|
    t.integer "membership_type", limit: 2, null: false
    t.boolean "visible", default: true, null: false
    t.string "email", null: false
    t.bigint "organization_id", null: false
    t.bigint "membership_id"
    t.bigint "user_id"
    t.bigint "sender_id"
    t.datetime "last_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_membership_invitations_on_email"
    t.index ["membership_id"], name: "index_membership_invitations_on_membership_id"
    t.index ["organization_id"], name: "index_membership_invitations_on_organization_id"
    t.index ["sender_id"], name: "index_membership_invitations_on_sender_id"
    t.index ["user_id"], name: "index_membership_invitations_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer "state", limit: 2, null: false
    t.datetime "accepted_at"
    t.integer "membership_type", limit: 2, null: false
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "organization_attachments", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.jsonb "attachment_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_data"], name: "index_organization_attachments_on_attachment_data", using: :gin
    t.index ["organization_id"], name: "index_organization_attachments_on_organization_id"
    t.index ["user_id"], name: "index_organization_attachments_on_user_id"
  end

  create_table "organization_job_tasks", force: :cascade do |t|
    t.integer "task_type", limit: 2
    t.integer "status", limit: 2
    t.integer "estimated_minutes"
    t.string "label", null: false
    t.bigint "job_id", null: false
    t.bigint "onsite_id"
    t.bigint "original_creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_organization_job_tasks_on_job_id"
    t.index ["onsite_id"], name: "index_organization_job_tasks_on_onsite_id"
    t.index ["original_creator_id"], name: "index_organization_job_tasks_on_original_creator_id"
  end

  create_table "organization_jobs", force: :cascade do |t|
    t.string "name"
    t.bigint "organization_id", null: false
    t.bigint "original_creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", limit: 2, null: false
    t.bigint "google_place_id"
    t.datetime "tasks_and_onsites_updated_at"
    t.index ["google_place_id"], name: "index_organization_jobs_on_google_place_id"
    t.index ["organization_id"], name: "index_organization_jobs_on_organization_id"
    t.index ["original_creator_id"], name: "index_organization_jobs_on_original_creator_id"
  end

  create_table "organization_notes", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "original_author_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.jsonb "tiptap_document", null: false
    t.timestamptz "created_at", precision: 6, null: false
    t.timestamptz "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_organization_notes_on_organization_id"
    t.index ["original_author_id"], name: "index_organization_notes_on_original_author_id"
    t.index ["resource_type", "resource_id"], name: "index_organization_notes_on_resource"
  end

  create_table "organization_onsites", force: :cascade do |t|
    t.bigint "original_creator_id", null: false
    t.bigint "job_id", null: false
    t.bigint "google_place_id"
    t.string "label"
    t.integer "priority", limit: 2, null: false
    t.integer "status", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "readonly_token_generated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "tasks_updated_at"
    t.index ["google_place_id"], name: "index_organization_onsites_on_google_place_id"
    t.index ["job_id"], name: "index_organization_onsites_on_job_id"
    t.index ["original_creator_id"], name: "index_organization_onsites_on_original_creator_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone", default: "UTC", null: false
  end

  create_table "user_emergency_passkey_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "user_passkey_id"
    t.bigint "utility_user_agent_id"
    t.bigint "utility_ip_address_id"
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_emergency_passkey_registrations_on_user_id"
    t.index ["user_passkey_id"], name: "index_user_emergency_passkey_registrations_on_user_passkey_id"
    t.index ["utility_ip_address_id"], name: "idx_on_utility_ip_address_id_4e5bc49679"
    t.index ["utility_user_agent_id"], name: "idx_on_utility_user_agent_id_7b65e12f43"
  end

  create_table "user_passkeys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "label", null: false
    t.string "external_id", null: false
    t.string "public_key", null: false
    t.integer "sign_count"
    t.datetime "last_used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_user_passkeys_on_external_id", unique: true
    t.index ["public_key"], name: "index_user_passkeys_on_public_key", unique: true
    t.index ["user_id"], name: "index_user_passkeys_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "webauthn_id", null: false
    t.string "name"
    t.text "remember_token", default: -> { "gen_salt('bf'::text)" }
    t.integer "theme", limit: 2, default: 0
    t.datetime "emergency_login_generated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
    t.index ["webauthn_id"], name: "index_users_on_webauthn_id", unique: true
  end

  create_table "utility_ip_addresses", force: :cascade do |t|
    t.inet "address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_utility_ip_addresses_on_address", unique: true
  end

  create_table "utility_user_agents", force: :cascade do |t|
    t.string "user_agent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_agent"], name: "index_utility_user_agents_on_user_agent", unique: true
  end

  add_foreign_key "administrator_emergency_passkey_registrations", "administrator_passkeys"
  add_foreign_key "administrator_emergency_passkey_registrations", "administrators"
  add_foreign_key "administrator_passkeys", "administrators"
  add_foreign_key "membership_invitations", "memberships"
  add_foreign_key "membership_invitations", "organizations"
  add_foreign_key "membership_invitations", "users"
  add_foreign_key "membership_invitations", "users", column: "sender_id"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "organization_job_tasks", "organization_jobs", column: "job_id"
  add_foreign_key "organization_job_tasks", "organization_onsites", column: "onsite_id"
  add_foreign_key "organization_job_tasks", "users", column: "original_creator_id"
  add_foreign_key "organization_jobs", "google_places"
  add_foreign_key "organization_jobs", "organizations"
  add_foreign_key "organization_jobs", "users", column: "original_creator_id"
  add_foreign_key "organization_notes", "organizations"
  add_foreign_key "organization_notes", "users", column: "original_author_id"
  add_foreign_key "organization_onsites", "google_places"
  add_foreign_key "organization_onsites", "organization_jobs", column: "job_id"
  add_foreign_key "organization_onsites", "users", column: "original_creator_id"
  add_foreign_key "user_emergency_passkey_registrations", "user_passkeys"
  add_foreign_key "user_emergency_passkey_registrations", "users"
  add_foreign_key "user_passkeys", "users"
end
