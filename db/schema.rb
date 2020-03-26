# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_26_092301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_budgets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.decimal "proposed_amount"
    t.integer "year"
    t.uuid "cooperative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_budgets_on_account_id"
    t.index ["cooperative_id"], name: "index_account_budgets_on_cooperative_id"
  end

  create_table "account_scopes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "scopeable_type", null: false
    t.uuid "scopeable_id", null: false
    t.string "account_type", null: false
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_type", "account_id"], name: "index_account_scopes_on_account_type_and_account_id"
    t.index ["scopeable_type", "scopeable_id"], name: "index_account_scopes_on_scopeable_type_and_scopeable_id"
  end

  create_table "accountable_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "accountable_type"
    t.uuid "accountable_id"
    t.uuid "account_id"
    t.index ["account_id"], name: "index_accountable_accounts_on_account_id"
    t.index ["accountable_type", "accountable_id"], name: "index_accountable_on_accountable_accounts"
  end

  create_table "accounting_report_account_categorizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "accounting_report_id", null: false
    t.string "account_category_type", null: false
    t.uuid "account_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_category_type", "account_category_id"], name: "index_accounting_category_on_acc_report_categorizations"
    t.index ["accounting_report_id"], name: "index_accounting_report_on_acc_report_categorizations"
  end

  create_table "accounting_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.uuid "office_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "report_type"
    t.index ["office_id"], name: "index_accounting_reports_on_office_id"
    t.index ["report_type"], name: "index_accounting_reports_on_report_type"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "contra", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.datetime "last_transaction_date"
    t.uuid "level_one_account_category_id"
    t.index ["code"], name: "index_accounts_on_code", unique: true
    t.index ["level_one_account_category_id"], name: "index_accounts_on_level_one_account_category_id"
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["type"], name: "index_accounts_on_type"
    t.index ["updated_at"], name: "index_accounts_on_updated_at"
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "trackable_type"
    t.uuid "trackable_id"
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.uuid "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "street"
    t.string "barangay"
    t.string "municipality"
    t.string "province"
    t.string "addressable_type"
    t.uuid "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "current", default: false
    t.uuid "street_id"
    t.uuid "barangay_id"
    t.uuid "municipality_id"
    t.uuid "province_id"
    t.string "complete_address"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["barangay_id"], name: "index_addresses_on_barangay_id"
    t.index ["municipality_id"], name: "index_addresses_on_municipality_id"
    t.index ["province_id"], name: "index_addresses_on_province_id"
    t.index ["street_id"], name: "index_addresses_on_street_id"
  end

  create_table "amortization_schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "schedule_type"
    t.boolean "prededucted_interest", default: false
    t.uuid "debit_account_id"
    t.uuid "credit_account_id"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.integer "payment_status"
    t.uuid "loan_application_id"
    t.decimal "principal", default: "0.0"
    t.decimal "interest", default: "0.0"
    t.uuid "cooperative_id"
    t.string "scheduleable_type"
    t.uuid "scheduleable_id"
    t.decimal "total_repayment"
    t.string "entry_ids", default: [], array: true
    t.decimal "ending_balance", default: "0.0", null: false
    t.uuid "office_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_amortization_schedules"
    t.index ["cooperative_id"], name: "index_amortization_schedules_on_cooperative_id"
    t.index ["credit_account_id"], name: "index_amortization_schedules_on_credit_account_id"
    t.index ["debit_account_id"], name: "index_amortization_schedules_on_debit_account_id"
    t.index ["loan_application_id"], name: "index_amortization_schedules_on_loan_application_id"
    t.index ["loan_id"], name: "index_amortization_schedules_on_loan_id"
    t.index ["office_id"], name: "index_amortization_schedules_on_office_id"
    t.index ["payment_status"], name: "index_amortization_schedules_on_payment_status"
    t.index ["schedule_type"], name: "index_amortization_schedules_on_schedule_type"
    t.index ["scheduleable_type", "scheduleable_id"], name: "index_schedulable_on_amortization_schedules"
  end

  create_table "amortization_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "calculation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repayment_calculation_type"
    t.integer "interest_amortization_scope"
    t.index ["calculation_type"], name: "index_amortization_types_on_calculation_type"
    t.index ["repayment_calculation_type"], name: "index_amortization_types_on_repayment_calculation_type"
  end

  create_table "amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "entry_id"
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "PHP", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.index ["account_id", "entry_id"], name: "index_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_amounts_on_account_id"
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_commercial_documents_on_accounting_amounts"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_amounts_on_commercial_document"
    t.index ["entry_id", "account_id"], name: "index_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_amounts_on_entry_id"
    t.index ["type"], name: "index_amounts_on_type"
  end

  create_table "archives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "record_type"
    t.uuid "record_id"
    t.uuid "archiver_id"
    t.datetime "archived_at"
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["archiver_id"], name: "index_archives_on_archiver_id"
    t.index ["record_type", "record_id"], name: "index_archives_on_record_type_and_record_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "automated_clearing_houses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "automatic_clearing_houses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bank_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "bank_name"
    t.string "bank_address"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "interest_revenue_account_id"
    t.uuid "cash_account_id"
    t.uuid "office_id"
    t.datetime "last_transaction_date"
    t.index ["cash_account_id"], name: "index_bank_accounts_on_cash_account_id"
    t.index ["cooperative_id"], name: "index_bank_accounts_on_cooperative_id"
    t.index ["interest_revenue_account_id"], name: "index_bank_accounts_on_interest_revenue_account_id"
    t.index ["office_id"], name: "index_bank_accounts_on_office_id"
  end

  create_table "banking_agent_carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "banking_agent_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["banking_agent_id"], name: "index_banking_agent_carts_on_banking_agent_id"
  end

  create_table "banking_agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "account_number"
    t.uuid "depository_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.uuid "cash_account_id"
    t.index ["cash_account_id"], name: "index_banking_agents_on_cash_account_id"
    t.index ["confirmation_token"], name: "index_banking_agents_on_confirmation_token", unique: true
    t.index ["depository_account_id"], name: "index_banking_agents_on_depository_account_id"
    t.index ["email"], name: "index_banking_agents_on_email", unique: true
    t.index ["reset_password_token"], name: "index_banking_agents_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_banking_agents_on_unlock_token", unique: true
  end

  create_table "barangays", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "municipality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_barangays_on_cooperative_id"
    t.index ["municipality_id"], name: "index_barangays_on_municipality_id"
    t.index ["name"], name: "index_barangays_on_name"
  end

  create_table "barcodes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "line_item_id"
    t.index ["line_item_id"], name: "index_barcodes_on_line_item_id"
  end

  create_table "beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.string "full_name"
    t.string "relationship"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_beneficiaries_on_cooperative_id"
    t.index ["member_id"], name: "index_beneficiaries_on_member_id"
  end

  create_table "bills", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "bill_amount"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_type"
    t.uuid "customer_id"
    t.index ["customer_type", "customer_id"], name: "index_carts_on_customer_type_and_customer_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "cash_count_reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employee_id"
    t.datetime "date"
    t.decimal "beginning_balance", default: "0.0", null: false
    t.decimal "ending_balance", default: "0.0", null: false
    t.decimal "difference", default: "0.0", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_cash_count_reports_on_employee_id"
  end

  create_table "cash_counts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "bill_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cash_count_report_id"
    t.uuid "cart_id"
    t.index ["bill_id"], name: "index_cash_counts_on_bill_id"
    t.index ["cart_id"], name: "index_cash_counts_on_cart_id"
    t.index ["cash_count_report_id"], name: "index_cash_counts_on_cash_count_report_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_categories_on_cooperative_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "clearing_house_depository_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "depositor_type", null: false
    t.uuid "depositor_id", null: false
    t.uuid "clearing_house_id", null: false
    t.uuid "depository_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["clearing_house_id"], name: "index_clearing_house_depository_accounts_on_clearing_house_id"
    t.index ["depositor_type", "depositor_id"], name: "index_depositor_on_clearing_house_dep_accounts"
    t.index ["depository_account_id"], name: "index_depository_account_on_clearing_house_dep_accounts"
  end

  create_table "committee_members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_committee_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_committee_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_committee_members_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_committee_members_on_unlock_token", unique: true
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "contactable_type"
    t.uuid "contactable_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "cooperative_banking_agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id", null: false
    t.uuid "banking_agent_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["banking_agent_id"], name: "index_cooperative_banking_agents_on_banking_agent_id"
    t.index ["cooperative_id"], name: "index_cooperative_banking_agents_on_cooperative_id"
  end

  create_table "cooperative_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_cooperative_services_on_cooperative_id"
  end

  create_table "cooperatives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.string "address"
    t.string "abbreviated_name"
    t.string "operating_days", default: [], array: true
    t.index ["abbreviated_name"], name: "index_cooperatives_on_abbreviated_name", unique: true
  end

  create_table "cooperators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_cooperators_on_confirmation_token", unique: true
    t.index ["email"], name: "index_cooperators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_cooperators_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_cooperators_on_unlock_token", unique: true
  end

  create_table "deactivations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "deactivatable_type"
    t.uuid "deactivatable_id"
    t.text "remarks"
    t.datetime "deactivated_at"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deactivatable_type", "deactivatable_id"], name: "index_deactivations_on_deactivatable_type_and_deactivatable_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "documentary_stamp_taxes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "taxable_type"
    t.bigint "taxable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.string "name"
    t.uuid "credit_account_id"
    t.uuid "debit_account_id"
    t.index ["credit_account_id"], name: "index_documentary_stamp_taxes_on_credit_account_id"
    t.index ["debit_account_id"], name: "index_documentary_stamp_taxes_on_debit_account_id"
    t.index ["taxable_type", "taxable_id"], name: "index_documentary_stamp_taxes_on_taxable_type_and_taxable_id"
  end

  create_table "employee_cash_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employee_id"
    t.uuid "cash_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.boolean "default_account", default: false
    t.index ["cash_account_id"], name: "index_employee_cash_accounts_on_cash_account_id"
    t.index ["cooperative_id"], name: "index_employee_cash_accounts_on_cooperative_id"
    t.index ["employee_id"], name: "index_employee_cash_accounts_on_employee_id"
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_number"
    t.datetime "entry_date"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.uuid "recorder_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "offline_receipt", default: false
    t.uuid "office_id"
    t.uuid "cooperative_id"
    t.uuid "official_receipt_id"
    t.boolean "cancelled", default: false
    t.datetime "cancelled_at"
    t.uuid "cancelled_by_id"
    t.uuid "cooperative_service_id"
    t.string "cancellation_description"
    t.boolean "archived", default: false
    t.uuid "cancellation_entry_id"
    t.datetime "entry_time"
    t.integer "ref_number_integer"
    t.string "origin_type"
    t.uuid "origin_id"
    t.string "recording_agent_type"
    t.uuid "recording_agent_id"
    t.index ["cancellation_entry_id"], name: "index_entries_on_cancellation_entry_id"
    t.index ["cancelled_by_id"], name: "index_entries_on_cancelled_by_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
    t.index ["cooperative_id"], name: "index_entries_on_cooperative_id"
    t.index ["cooperative_service_id"], name: "index_entries_on_cooperative_service_id"
    t.index ["entry_date"], name: "index_entries_on_entry_date"
    t.index ["office_id"], name: "index_entries_on_office_id"
    t.index ["official_receipt_id"], name: "index_entries_on_official_receipt_id"
    t.index ["origin_type", "origin_id"], name: "index_entries_on_origin_type_and_origin_id"
    t.index ["recorder_id"], name: "index_entries_on_recorder_id"
    t.index ["recording_agent_type", "recording_agent_id"], name: "index_entries_on_recording_agent_type_and_recording_agent_id"
  end

  create_table "financial_condition_comparisons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "first_date"
    t.datetime "second_date"
    t.integer "comparison_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comparison_type"], name: "index_financial_condition_comparisons_on_comparison_type"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "grace_periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "number_of_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "identifiable_type"
    t.uuid "identifiable_id"
    t.uuid "identity_provider_id"
    t.string "number"
    t.datetime "issuance_date"
    t.datetime "expiry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "previous_identification_id"
    t.string "previous_id_hash"
    t.string "encrypted_hash"
    t.index ["encrypted_hash"], name: "index_identifications_on_encrypted_hash", unique: true
    t.index ["identifiable_type", "identifiable_id"], name: "index_identifications_on_identifiable_type_and_identifiable_id"
    t.index ["identity_provider_id"], name: "index_identifications_on_identity_provider_id"
    t.index ["previous_id_hash"], name: "index_identifications_on_previous_id_hash", unique: true
    t.index ["previous_identification_id"], name: "index_identifications_on_previous_identification_id"
  end

  create_table "identity_providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviated_name"
    t.index ["abbreviated_name"], name: "index_identity_providers_on_abbreviated_name", unique: true
  end

  create_table "income_source_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_income_source_categories_on_title", unique: true
  end

  create_table "income_sources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "designation"
    t.string "description"
    t.decimal "monthly_income"
    t.uuid "income_source_category_id", null: false
    t.uuid "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["income_source_category_id"], name: "index_income_sources_on_income_source_category_id"
    t.index ["member_id"], name: "index_income_sources_on_member_id"
  end

  create_table "interest_amortizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "calculation_type", null: false
    t.index ["calculation_type"], name: "index_interest_amortizations_on_calculation_type"
  end

  create_table "interest_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "add_on_interest"
    t.uuid "interest_revenue_account_id"
    t.uuid "unearned_interest_income_account_id"
    t.integer "interest_type"
    t.uuid "cooperative_id"
    t.integer "calculation_type"
    t.integer "prededuction_type"
    t.decimal "prededucted_rate"
    t.integer "amortization_type", default: 0
    t.integer "prededucted_number_of_payments"
    t.decimal "prededucted_amount"
    t.integer "rate_type"
    t.string "type"
    t.uuid "accrued_income_account_id"
    t.uuid "past_due_interest_income_account_id"
    t.index ["accrued_income_account_id"], name: "index_interest_configs_on_accrued_income_account_id"
    t.index ["amortization_type"], name: "index_interest_configs_on_amortization_type"
    t.index ["calculation_type"], name: "index_interest_configs_on_calculation_type"
    t.index ["cooperative_id"], name: "index_interest_configs_on_cooperative_id"
    t.index ["interest_revenue_account_id"], name: "index_interest_configs_on_interest_revenue_account_id"
    t.index ["interest_type"], name: "index_interest_configs_on_interest_type"
    t.index ["loan_product_id"], name: "index_interest_configs_on_loan_product_id"
    t.index ["past_due_interest_income_account_id"], name: "index_interest_configs_on_past_due_interest_income_account_id"
    t.index ["prededuction_type"], name: "index_interest_configs_on_prededuction_type"
    t.index ["rate_type"], name: "index_interest_configs_on_rate_type"
    t.index ["type"], name: "index_interest_configs_on_type"
    t.index ["unearned_interest_income_account_id"], name: "index_interest_configs_on_unearned_interest_income_account_id"
  end

  create_table "interest_predeductions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.integer "calculation_type"
    t.decimal "rate"
    t.decimal "amount"
    t.integer "number_of_payments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prededuction_scope", default: 0
    t.index ["calculation_type"], name: "index_interest_predeductions_on_calculation_type"
    t.index ["loan_product_id"], name: "index_interest_predeductions_on_loan_product_id"
    t.index ["prededuction_scope"], name: "index_interest_predeductions_on_prededuction_scope"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoiceable_type"
    t.uuid "invoiceable_id"
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_invoices_on_invoiceable_type_and_invoiceable_id"
    t.index ["number"], name: "index_invoices_on_number", unique: true
    t.index ["type"], name: "index_invoices_on_type"
  end

  create_table "leads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "message"
  end

  create_table "level_four_account_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "office_id", null: false
    t.string "code"
    t.string "type"
    t.boolean "contra", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["office_id"], name: "index_level_four_account_categories_on_office_id"
    t.index ["type"], name: "index_level_four_account_categories_on_type"
  end

  create_table "level_one_account_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_id"
    t.string "title"
    t.string "code"
    t.boolean "contra"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "level_two_account_category_id"
    t.string "categorizeable_type"
    t.uuid "categorizeable_id"
    t.index ["categorizeable_type", "categorizeable_id"], name: "index_categorizeable_on_level_one_account_categories"
    t.index ["level_two_account_category_id"], name: "index_level_2_act_category_on_level_1_act_categories"
    t.index ["office_id"], name: "index_level_one_account_categories_on_office_id"
    t.index ["type"], name: "index_level_one_account_categories_on_type"
  end

  create_table "level_three_account_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "code", null: false
    t.uuid "office_id", null: false
    t.boolean "contra", default: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "level_four_account_category_id"
    t.boolean "show_sub_categories", default: true
    t.index ["level_four_account_category_id"], name: "index_l4_account_category_on_l3_account_categories"
    t.index ["office_id"], name: "index_level_three_account_categories_on_office_id"
    t.index ["type"], name: "index_level_three_account_categories_on_type"
  end

  create_table "level_two_account_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "office_id"
    t.string "code"
    t.string "type"
    t.boolean "contra"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "level_three_account_category_id"
    t.boolean "show_sub_categories", default: true
    t.index ["level_three_account_category_id"], name: "index_l3_account_category_on_l2_account_categories"
    t.index ["office_id"], name: "index_level_two_account_categories_on_office_id"
    t.index ["type"], name: "index_level_two_account_categories_on_type"
  end

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "order_id"
    t.uuid "cart_id"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "unit_of_measurement_id"
    t.string "type"
    t.uuid "referenced_line_item_id"
    t.uuid "purchase_line_item_id"
    t.uuid "sales_line_item_id"
    t.datetime "expiry_date"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["purchase_line_item_id"], name: "index_line_items_on_purchase_line_item_id"
    t.index ["referenced_line_item_id"], name: "index_line_items_on_referenced_line_item_id"
    t.index ["sales_line_item_id"], name: "index_line_items_on_sales_line_item_id"
    t.index ["type"], name: "index_line_items_on_type"
    t.index ["unit_of_measurement_id"], name: "index_line_items_on_unit_of_measurement_id"
  end

  create_table "loan_aging_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.integer "start_num"
    t.integer "end_num"
    t.uuid "office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "level_two_account_category_id"
    t.index ["level_two_account_category_id"], name: "index_loan_aging_groups_on_level_two_account_category_id"
    t.index ["office_id"], name: "index_loan_aging_groups_on_office_id"
  end

  create_table "loan_agings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.uuid "loan_aging_group_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "receivable_account_id"
    t.index ["loan_aging_group_id"], name: "index_loan_agings_on_loan_aging_group_id"
    t.index ["loan_id"], name: "index_loan_agings_on_loan_id"
    t.index ["receivable_account_id"], name: "index_loan_agings_on_receivable_account_id"
  end

  create_table "loan_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "borrower_type"
    t.uuid "borrower_id"
    t.decimal "term", null: false
    t.decimal "loan_amount"
    t.datetime "application_date"
    t.integer "mode_of_payment"
    t.string "account_number"
    t.uuid "preparer_id"
    t.uuid "cooperative_id"
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "office_id"
    t.text "purpose"
    t.uuid "organization_id"
    t.uuid "voucher_id"
    t.integer "loan_amount_cents", default: 0, null: false
    t.string "loan_amount_currency", default: "PHP", null: false
    t.boolean "approved", default: false
    t.boolean "cancelled", default: false
    t.datetime "approved_at"
    t.decimal "annual_interest_rate"
    t.uuid "receivable_account_id"
    t.uuid "interest_revenue_account_id"
    t.integer "number_of_days"
    t.decimal "interest_rate", default: "0.0"
    t.uuid "cart_id"
    t.index ["borrower_type", "borrower_id"], name: "index_loan_applications_on_borrower_type_and_borrower_id"
    t.index ["cart_id"], name: "index_loan_applications_on_cart_id"
    t.index ["cooperative_id"], name: "index_loan_applications_on_cooperative_id"
    t.index ["interest_revenue_account_id"], name: "index_loan_applications_on_interest_revenue_account_id"
    t.index ["loan_product_id"], name: "index_loan_applications_on_loan_product_id"
    t.index ["office_id"], name: "index_loan_applications_on_office_id"
    t.index ["organization_id"], name: "index_loan_applications_on_organization_id"
    t.index ["preparer_id"], name: "index_loan_applications_on_preparer_id"
    t.index ["receivable_account_id"], name: "index_loan_applications_on_receivable_account_id"
    t.index ["voucher_id"], name: "index_loan_applications_on_voucher_id"
  end

  create_table "loan_charge_payment_schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "schedule_type"
    t.datetime "date"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "amortization_schedule_id"
    t.uuid "loan_id"
    t.index ["amortization_schedule_id"], name: "index_loan_charge_payment_schedules_on_amortization_schedule_id"
    t.index ["loan_id"], name: "index_loan_charge_payment_schedules_on_loan_id"
    t.index ["schedule_type"], name: "index_loan_charge_payment_schedules_on_schedule_type"
  end

  create_table "loan_co_makers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.string "co_maker_type"
    t.uuid "co_maker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["co_maker_type", "co_maker_id"], name: "index_loan_co_makers_on_co_maker_type_and_co_maker_id"
    t.index ["loan_id"], name: "index_loan_co_makers_on_loan_id"
  end

  create_table "loan_discounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.datetime "date"
    t.integer "discount_type"
    t.text "description"
    t.uuid "computed_by_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["computed_by_id"], name: "index_loan_discounts_on_computed_by_id"
    t.index ["discount_type"], name: "index_loan_discounts_on_discount_type"
    t.index ["loan_id"], name: "index_loan_discounts_on_loan_id"
  end

  create_table "loan_interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.decimal "amount"
    t.datetime "date"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "computed_by_id"
    t.index ["computed_by_id"], name: "index_loan_interests_on_computed_by_id"
    t.index ["loan_id"], name: "index_loan_interests_on_loan_id"
  end

  create_table "loan_penalties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.decimal "amount"
    t.datetime "date"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "computed_by_id"
    t.index ["computed_by_id"], name: "index_loan_penalties_on_computed_by_id"
    t.index ["loan_id"], name: "index_loan_penalties_on_loan_id"
  end

  create_table "loan_product_charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.decimal "amount"
    t.decimal "rate"
    t.uuid "account_id"
    t.integer "charge_type"
    t.index ["account_id"], name: "index_loan_product_charges_on_account_id"
    t.index ["loan_product_id"], name: "index_loan_product_charges_on_loan_product_id"
  end

  create_table "loan_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.decimal "maximum_loanable_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.decimal "minimum_loanable_amount"
    t.string "slug"
    t.uuid "current_account_id"
    t.uuid "past_due_account_id"
    t.uuid "cooperative_id"
    t.uuid "loan_protection_plan_provider_id"
    t.decimal "grace_period", default: "0.0"
    t.boolean "active", default: true
    t.uuid "restructured_account_id"
    t.uuid "amortization_type_id"
    t.uuid "litigation_account_id"
    t.boolean "adjustable_interest_rate", default: false
    t.uuid "office_id"
    t.uuid "interest_amortization_id"
    t.uuid "total_repayment_amortization_id"
    t.index ["amortization_type_id"], name: "index_loan_products_on_amortization_type_id"
    t.index ["cooperative_id"], name: "index_loan_products_on_cooperative_id"
    t.index ["current_account_id"], name: "index_loan_products_on_current_account_id"
    t.index ["interest_amortization_id"], name: "index_loan_products_on_interest_amortization_id"
    t.index ["litigation_account_id"], name: "index_loan_products_on_litigation_account_id"
    t.index ["loan_protection_plan_provider_id"], name: "index_loan_products_on_loan_protection_plan_provider_id"
    t.index ["name"], name: "index_loan_products_on_name", unique: true
    t.index ["office_id"], name: "index_loan_products_on_office_id"
    t.index ["past_due_account_id"], name: "index_loan_products_on_past_due_account_id"
    t.index ["restructured_account_id"], name: "index_loan_products_on_restructured_account_id"
    t.index ["slug"], name: "index_loan_products_on_slug", unique: true
    t.index ["total_repayment_amortization_id"], name: "index_loan_products_on_total_repayment_amortization_id"
  end

  create_table "loan_protection_plan_providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "business_name"
    t.decimal "rate"
    t.uuid "cooperative_id"
    t.uuid "accounts_payable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accounts_payable_id"], name: "index_loan_protection_plan_providers_on_accounts_payable_id"
    t.index ["cooperative_id"], name: "index_loan_protection_plan_providers_on_cooperative_id"
  end

  create_table "loans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.decimal "loan_amount"
    t.integer "mode_of_payment"
    t.datetime "application_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "barangay_id"
    t.uuid "street_id"
    t.uuid "municipality_id"
    t.uuid "organization_id"
    t.string "borrower_type"
    t.uuid "borrower_id"
    t.string "borrower_full_name"
    t.uuid "preparer_id"
    t.string "account_number"
    t.boolean "archived", default: false
    t.text "purpose"
    t.datetime "archiving_date"
    t.string "tracking_number"
    t.uuid "archived_by_id"
    t.datetime "last_transaction_date"
    t.uuid "voucher_id"
    t.uuid "cooperative_id"
    t.uuid "disbursement_voucher_id"
    t.uuid "office_id"
    t.boolean "forwarded_loan", default: false
    t.uuid "loan_application_id"
    t.integer "status"
    t.string "type"
    t.boolean "cancelled", default: false
    t.string "code"
    t.uuid "receivable_account_id"
    t.uuid "interest_revenue_account_id"
    t.uuid "penalty_revenue_account_id"
    t.uuid "accrued_income_account_id"
    t.datetime "date_archived"
    t.datetime "paid_at"
    t.uuid "loan_aging_group_id"
    t.index ["account_number"], name: "index_loans_on_account_number", unique: true
    t.index ["accrued_income_account_id"], name: "index_loans_on_accrued_income_account_id"
    t.index ["archived_by_id"], name: "index_loans_on_archived_by_id"
    t.index ["barangay_id"], name: "index_loans_on_barangay_id"
    t.index ["borrower_type", "borrower_id"], name: "index_loans_on_borrower_type_and_borrower_id"
    t.index ["code"], name: "index_loans_on_code", unique: true
    t.index ["cooperative_id"], name: "index_loans_on_cooperative_id"
    t.index ["disbursement_voucher_id"], name: "index_loans_on_disbursement_voucher_id"
    t.index ["interest_revenue_account_id"], name: "index_loans_on_interest_revenue_account_id"
    t.index ["loan_aging_group_id"], name: "index_loans_on_loan_aging_group_id"
    t.index ["loan_application_id"], name: "index_loans_on_loan_application_id"
    t.index ["loan_product_id"], name: "index_loans_on_loan_product_id"
    t.index ["municipality_id"], name: "index_loans_on_municipality_id"
    t.index ["office_id"], name: "index_loans_on_office_id"
    t.index ["organization_id"], name: "index_loans_on_organization_id"
    t.index ["penalty_revenue_account_id"], name: "index_loans_on_penalty_revenue_account_id"
    t.index ["preparer_id"], name: "index_loans_on_preparer_id"
    t.index ["receivable_account_id"], name: "index_loans_on_receivable_account_id"
    t.index ["status"], name: "index_loans_on_status"
    t.index ["street_id"], name: "index_loans_on_street_id"
    t.index ["type"], name: "index_loans_on_type"
    t.index ["voucher_id"], name: "index_loans_on_voucher_id"
  end

  create_table "mark_up_prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "price"
    t.datetime "date"
    t.uuid "unit_of_measurement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["unit_of_measurement_id"], name: "index_mark_up_prices_on_unit_of_measurement_id"
  end

  create_table "member_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.uuid "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_member_accounts_on_confirmation_token", unique: true
    t.index ["email"], name: "index_member_accounts_on_email", unique: true
    t.index ["member_id"], name: "index_member_accounts_on_member_id"
    t.index ["reset_password_token"], name: "index_member_accounts_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_member_accounts_on_unlock_token", unique: true
  end

  create_table "member_occupations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.uuid "occupation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_occupations_on_member_id"
    t.index ["occupation_id"], name: "index_member_occupations_on_occupation_id"
  end

  create_table "members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "sex"
    t.integer "civil_status"
    t.date "date_of_birth"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "birth_month"
    t.integer "birth_day"
    t.string "email", default: "", null: false
    t.integer "birth_year"
    t.datetime "last_transaction_date"
    t.uuid "cart_id"
    t.string "account_number"
    t.datetime "retired_at"
    t.index ["account_number"], name: "index_members_on_account_number", unique: true
    t.index ["cart_id"], name: "index_members_on_cart_id"
    t.index ["sex"], name: "index_members_on_sex"
    t.index ["slug"], name: "index_members_on_slug", unique: true
  end

  create_table "membership_beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "membership_id"
    t.string "beneficiary_type"
    t.uuid "beneficiary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beneficiary_type", "beneficiary_id"], name: "inde_beneficiary_on_membership_beneficiaries"
    t.index ["membership_id"], name: "index_membership_beneficiaries_on_membership_id"
  end

  create_table "membership_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "cooperative_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cooperative_id"], name: "index_membership_categories_on_cooperative_id"
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "membership_date"
    t.uuid "cooperative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.datetime "application_date"
    t.datetime "approval_date"
    t.integer "status"
    t.string "beneficiary_type"
    t.uuid "beneficiary_id"
    t.string "search_term"
    t.string "cooperator_type"
    t.uuid "cooperator_id"
    t.uuid "office_id"
    t.uuid "membership_category_id"
    t.index ["account_number"], name: "index_memberships_on_account_number", unique: true
    t.index ["beneficiary_type", "beneficiary_id"], name: "index_memberships_on_beneficiary_type_and_beneficiary_id"
    t.index ["cooperative_id"], name: "index_memberships_on_cooperative_id"
    t.index ["cooperator_type", "cooperator_id"], name: "index_memberships_on_cooperator_type_and_cooperator_id"
    t.index ["membership_category_id"], name: "index_memberships_on_membership_category_id"
    t.index ["office_id"], name: "index_memberships_on_office_id"
    t.index ["status"], name: "index_memberships_on_status"
  end

  create_table "merchants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "cooperative_id"
    t.uuid "liability_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_merchants_on_cooperative_id"
    t.index ["liability_account_id"], name: "index_merchants_on_liability_account_id"
  end

  create_table "municipalities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "province_id"
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_municipalities_on_cooperative_id"
    t.index ["name"], name: "index_municipalities_on_name"
    t.index ["province_id"], name: "index_municipalities_on_province_id"
  end

  create_table "net_income_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_id", null: false
    t.uuid "net_surplus_account_id", null: false
    t.integer "book_closing"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "net_loss_account_id"
    t.uuid "total_revenue_account_id"
    t.uuid "total_expense_account_id"
    t.uuid "interest_on_capital_account_id"
    t.index ["book_closing"], name: "index_net_income_configs_on_book_closing"
    t.index ["interest_on_capital_account_id"], name: "index_net_income_configs_on_interest_on_capital_account_id"
    t.index ["net_loss_account_id"], name: "index_net_income_configs_on_net_loss_account_id"
    t.index ["net_surplus_account_id"], name: "index_net_income_configs_on_net_surplus_account_id"
    t.index ["office_id"], name: "index_net_income_configs_on_office_id"
    t.index ["total_expense_account_id"], name: "index_net_income_configs_on_total_expense_account_id"
    t.index ["total_revenue_account_id"], name: "index_net_income_configs_on_total_revenue_account_id"
  end

  create_table "net_income_distributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.decimal "rate"
    t.string "description"
    t.uuid "cooperative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_net_income_distributions_on_account_id"
    t.index ["cooperative_id"], name: "index_net_income_distributions_on_cooperative_id"
  end

  create_table "notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "noteable_type"
    t.uuid "noteable_id"
    t.uuid "noter_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
    t.index ["noter_id"], name: "index_notes_on_noter_id"
  end

  create_table "notices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.string "type"
    t.string "notified_type"
    t.bigint "notified_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notified_type", "notified_id"], name: "index_notices_on_notified_type_and_notified_id"
    t.index ["type"], name: "index_notices_on_type"
  end

  create_table "occupations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "office_loan_product_aging_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_loan_product_id", null: false
    t.uuid "loan_aging_group_id", null: false
    t.uuid "level_one_account_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["level_one_account_category_id"], name: "index_account_categories_on_office_loan_product_aging_groups"
    t.index ["loan_aging_group_id"], name: "index_loan_aging_groups_on_office_loan_product_aging_groups"
    t.index ["office_loan_product_id"], name: "index_office_loan_products_on_office_loan_product_aging_groups"
  end

  create_table "office_loan_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_id", null: false
    t.uuid "loan_product_id", null: false
    t.uuid "interest_revenue_account_category_id", null: false
    t.uuid "penalty_revenue_account_category_id", null: false
    t.uuid "loan_protection_plan_provider_id", null: false
    t.uuid "forwarding_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["forwarding_account_id"], name: "index_office_loan_products_on_forwarding_account_id"
    t.index ["interest_revenue_account_category_id"], name: "index_interest_revenue_category_on_office_loan_products"
    t.index ["loan_product_id"], name: "index_office_loan_products_on_loan_product_id"
    t.index ["loan_protection_plan_provider_id"], name: "index_office_loan_products_on_loan_protection_plan_provider_id"
    t.index ["office_id"], name: "index_office_loan_products_on_office_id"
    t.index ["penalty_revenue_account_category_id"], name: "index_penalty_revenue_category_on_office_loan_products"
  end

  create_table "office_programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id", null: false
    t.uuid "office_id", null: false
    t.uuid "level_one_account_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["level_one_account_category_id"], name: "index_office_programs_on_level_one_account_category_id"
    t.index ["office_id"], name: "index_office_programs_on_office_id"
    t.index ["program_id"], name: "index_office_programs_on_program_id"
  end

  create_table "office_saving_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "liability_account_category_id", null: false
    t.uuid "interest_expense_account_category_id", null: false
    t.uuid "office_id", null: false
    t.uuid "closing_account_category_id", null: false
    t.uuid "forwarding_account_id", null: false
    t.uuid "saving_product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["closing_account_category_id"], name: "index_office_saving_products_on_closing_account_category_id"
    t.index ["forwarding_account_id"], name: "index_office_saving_products_on_forwarding_account_id"
    t.index ["interest_expense_account_category_id"], name: "index_int_expense_category_on_office_saving_products"
    t.index ["liability_account_category_id"], name: "index_office_saving_products_on_liability_account_category_id"
    t.index ["office_id"], name: "index_office_saving_products_on_office_id"
    t.index ["saving_product_id"], name: "index_office_saving_products_on_saving_product_id"
  end

  create_table "office_share_capital_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "share_capital_product_id", null: false
    t.uuid "office_id", null: false
    t.uuid "equity_account_category_id", null: false
    t.uuid "forwarding_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["equity_account_category_id"], name: "index_equity_account_category_on_office_share_capital_products"
    t.index ["forwarding_account_id"], name: "index_office_share_capital_products_on_forwarding_account_id"
    t.index ["office_id"], name: "index_office_share_capital_products_on_office_id"
    t.index ["share_capital_product_id"], name: "index_office_share_capital_products_on_share_capital_product_id"
  end

  create_table "office_time_deposit_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_id", null: false
    t.uuid "liability_account_category_id", null: false
    t.uuid "interest_expense_account_category_id", null: false
    t.uuid "break_contract_account_category_id", null: false
    t.uuid "time_deposit_product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "forwarding_account_id", null: false
    t.index ["break_contract_account_category_id"], name: "index_break_contract_category_on_office_time_deposit_products"
    t.index ["forwarding_account_id"], name: "index_office_time_deposit_products_on_forwarding_account_id"
    t.index ["interest_expense_account_category_id"], name: "index_interest_expense_category_on_office_time_deposit_products"
    t.index ["liability_account_category_id"], name: "index_liability_category_on_office_time_deposit_products"
    t.index ["office_id"], name: "index_office_time_deposit_products_on_office_id"
    t.index ["time_deposit_product_id"], name: "index_office_time_deposit_products_on_time_deposit_product_id"
  end

  create_table "offices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.uuid "cooperative_id"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_offices_on_cooperative_id"
    t.index ["type"], name: "index_offices_on_type"
  end

  create_table "official_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "receiptable_type"
    t.uuid "receiptable_id"
    t.index ["receiptable_type", "receiptable_id"], name: "index_official_receipts_on_receiptable_type_and_receiptable_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.integer "pay_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cash_tendered"
    t.decimal "total_cost"
    t.decimal "order_change"
    t.uuid "employee_id"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.string "type"
    t.boolean "credit", default: false
    t.string "commercial_document_name"
    t.uuid "store_front_id"
    t.uuid "cooperative_id"
    t.uuid "voucher_id"
    t.string "description"
    t.uuid "destination_store_front_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_orders"
    t.index ["cooperative_id"], name: "index_orders_on_cooperative_id"
    t.index ["destination_store_front_id"], name: "index_orders_on_destination_store_front_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["pay_type"], name: "index_orders_on_pay_type"
    t.index ["store_front_id"], name: "index_orders_on_store_front_id"
    t.index ["type"], name: "index_orders_on_type"
    t.index ["voucher_id"], name: "index_orders_on_voucher_id"
  end

  create_table "organization_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization_membership_type"
    t.uuid "organization_membership_id"
    t.index ["organization_id"], name: "index_organization_members_on_organization_id"
    t.index ["organization_membership_type", "organization_membership_id"], name: "index_on_organization_members_membership"
  end

  create_table "organization_scopes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id", null: false
    t.string "account_type", null: false
    t.uuid "account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_type", "account_id"], name: "index_organization_scopes_on_account_type_and_account_id"
    t.index ["organization_id"], name: "index_organization_scopes_on_organization_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_transaction_date"
    t.uuid "cooperative_id"
    t.string "abbreviated_name"
    t.index ["cooperative_id"], name: "index_organizations_on_cooperative_id"
  end

  create_table "ownerships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "owner_type"
    t.uuid "owner_id"
    t.string "ownable_type"
    t.uuid "ownable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ownable_type", "ownable_id"], name: "index_ownerships_on_ownable_type_and_ownable_id"
    t.index ["owner_type", "owner_id"], name: "index_ownerships_on_owner_type_and_owner_id"
  end

  create_table "penalty_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.decimal "rate"
    t.uuid "penalty_revenue_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_penalty_configs_on_cooperative_id"
    t.index ["loan_product_id"], name: "index_penalty_configs_on_loan_product_id"
    t.index ["penalty_revenue_account_id"], name: "index_penalty_configs_on_penalty_revenue_account_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.uuid "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.text "database"
    t.text "user"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.bigint "calls"
    t.datetime "captured_at"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.uuid "category_id"
    t.string "unit_of_measurement"
    t.uuid "cooperative_id"
    t.uuid "store_front_id"
    t.boolean "tracked", default: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["cooperative_id"], name: "index_products_on_cooperative_id"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["store_front_id"], name: "index_products_on_store_front_id"
  end

  create_table "program_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscriber_type"
    t.uuid "subscriber_id"
    t.datetime "date_subscribed"
    t.uuid "account_id"
    t.uuid "office_id"
    t.string "account_number"
    t.index ["account_id"], name: "index_program_subscriptions_on_account_id"
    t.index ["account_number"], name: "index_program_subscriptions_on_account_number", unique: true
    t.index ["office_id"], name: "index_program_subscriptions_on_office_id"
    t.index ["program_id"], name: "index_program_subscriptions_on_program_id"
    t.index ["subscriber_type", "subscriber_id"], name: "index_subscriber_in_program_subscriptions"
  end

  create_table "programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "default_program", default: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.integer "payment_schedule_type"
    t.uuid "cooperative_id"
    t.decimal "amount"
    t.uuid "level_one_account_category_id"
    t.index ["account_id"], name: "index_programs_on_account_id"
    t.index ["cooperative_id"], name: "index_programs_on_cooperative_id"
    t.index ["level_one_account_category_id"], name: "index_programs_on_level_one_account_category_id"
    t.index ["payment_schedule_type"], name: "index_programs_on_payment_schedule_type"
  end

  create_table "provinces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_provinces_on_name", unique: true
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "supplier_id"
    t.string "number"
    t.uuid "employee_id"
    t.uuid "cooperative_id"
    t.uuid "store_front_id"
    t.uuid "office_id"
    t.index ["cooperative_id"], name: "index_registries_on_cooperative_id"
    t.index ["employee_id"], name: "index_registries_on_employee_id"
    t.index ["office_id"], name: "index_registries_on_office_id"
    t.index ["store_front_id"], name: "index_registries_on_store_front_id"
    t.index ["supplier_id"], name: "index_registries_on_supplier_id"
    t.index ["type"], name: "index_registries_on_type"
  end

  create_table "relationships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "relationship_type"
    t.string "relationee_type"
    t.uuid "relationee_id"
    t.string "relationer_type"
    t.uuid "relationer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["relationee_type", "relationee_id"], name: "index_relationships_on_relationee_type_and_relationee_id"
    t.index ["relationer_type", "relationer_id"], name: "index_relationships_on_relationer_type_and_relationer_id"
    t.index ["relationship_type"], name: "index_relationships_on_relationship_type"
  end

  create_table "sales_purchase_line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sales_line_item_id"
    t.uuid "purchase_line_item_id"
    t.decimal "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_line_item_id"], name: "index_sales_purchase_line_items_on_purchase_line_item_id"
    t.index ["sales_line_item_id"], name: "index_sales_purchase_line_items_on_sales_line_item_id"
  end

  create_table "saving_product_interest_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "interest_expense_category_id", null: false
    t.uuid "saving_product_id", null: false
    t.integer "interest_posting", default: 0
    t.decimal "annual_rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "minimum_balance"
    t.index ["interest_expense_category_id"], name: "index_interest_category_on_saving_product_interest_configs"
    t.index ["interest_posting"], name: "index_saving_product_interest_configs_on_interest_posting"
    t.index ["saving_product_id"], name: "index_saving_product_interest_configs_on_saving_product_id"
  end

  create_table "saving_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "interest_rate"
    t.integer "interest_recurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.decimal "minimum_balance"
    t.uuid "closing_account_id"
    t.uuid "interest_expense_account_id"
    t.boolean "has_closing_account_fee", default: false
    t.integer "dormancy_number_of_days", default: 0
    t.uuid "cooperative_id"
    t.decimal "closing_account_fee", default: "0.0"
    t.uuid "office_id"
    t.boolean "can_earn_interest", default: false
    t.index ["account_id"], name: "index_saving_products_on_account_id"
    t.index ["closing_account_id"], name: "index_saving_products_on_closing_account_id"
    t.index ["cooperative_id"], name: "index_saving_products_on_cooperative_id"
    t.index ["interest_expense_account_id"], name: "index_saving_products_on_interest_expense_account_id"
    t.index ["office_id"], name: "index_saving_products_on_office_id"
  end

  create_table "savings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "account_number"
    t.string "account_owner_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "saving_product_id"
    t.uuid "office_id"
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.datetime "date_opened"
    t.uuid "barangay_id"
    t.boolean "has_minimum_balance", default: false
    t.uuid "cooperative_id"
    t.boolean "archived"
    t.datetime "archived_at"
    t.uuid "organization_id"
    t.string "beneficiaries"
    t.string "code"
    t.uuid "interest_expense_account_id"
    t.uuid "liability_account_id"
    t.boolean "can_earn_interest", default: false
    t.integer "averaged_balance_cents", default: 0, null: false
    t.string "averaged_balance_currency", default: "PHP", null: false
    t.datetime "closed_at"
    t.index ["account_number"], name: "index_savings_on_account_number", unique: true
    t.index ["account_owner_name"], name: "index_savings_on_account_owner_name"
    t.index ["barangay_id"], name: "index_savings_on_barangay_id"
    t.index ["code"], name: "index_savings_on_code", unique: true
    t.index ["cooperative_id"], name: "index_savings_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_savings_on_depositor_type_and_depositor_id"
    t.index ["interest_expense_account_id"], name: "index_savings_on_interest_expense_account_id"
    t.index ["liability_account_id"], name: "index_savings_on_liability_account_id"
    t.index ["office_id"], name: "index_savings_on_office_id"
    t.index ["organization_id"], name: "index_savings_on_organization_id"
    t.index ["saving_product_id"], name: "index_savings_on_saving_product_id"
  end

  create_table "savings_account_agings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "savings_account_id", null: false
    t.uuid "savings_aging_group_id", null: false
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["savings_account_id"], name: "index_savings_account_agings_on_savings_account_id"
    t.index ["savings_aging_group_id"], name: "index_savings_account_agings_on_savings_aging_group_id"
  end

  create_table "savings_account_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.uuid "saving_product_id"
    t.datetime "date_opened"
    t.decimal "initial_deposit"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.string "beneficiaries"
    t.uuid "liability_account_id"
    t.uuid "office_id"
    t.index ["cooperative_id"], name: "index_savings_account_applications_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_depositor_on_savings_account_applications"
    t.index ["liability_account_id"], name: "index_savings_account_applications_on_liability_account_id"
    t.index ["office_id"], name: "index_savings_account_applications_on_office_id"
    t.index ["saving_product_id"], name: "index_savings_account_applications_on_saving_product_id"
  end

  create_table "savings_aging_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "office_id", null: false
    t.integer "start_num", null: false
    t.integer "end_num", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["office_id"], name: "index_savings_aging_groups_on_office_id"
  end

  create_table "share_capital_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "subscriber_type"
    t.uuid "subscriber_id"
    t.uuid "share_capital_product_id"
    t.uuid "cooperative_id"
    t.uuid "office_id"
    t.decimal "initial_capital"
    t.string "account_number"
    t.datetime "date_opened"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "beneficiaries"
    t.uuid "equity_account_id"
    t.index ["cooperative_id"], name: "index_share_capital_applications_on_cooperative_id"
    t.index ["equity_account_id"], name: "index_share_capital_applications_on_equity_account_id"
    t.index ["office_id"], name: "index_share_capital_applications_on_office_id"
    t.index ["share_capital_product_id"], name: "index_share_capital_applications_on_share_capital_product_id"
    t.index ["subscriber_type", "subscriber_id"], name: "index_subscriber_on_share_capital_applications"
  end

  create_table "share_capital_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "minimum_number_of_subscribed_share"
    t.decimal "minimum_number_of_paid_share"
    t.boolean "default_product", default: false
    t.uuid "equity_account_id"
    t.decimal "cost_per_share"
    t.boolean "has_closing_account_fee", default: false
    t.decimal "closing_account_fee", default: "0.0"
    t.decimal "minimum_balance", default: "0.0"
    t.uuid "cooperative_id"
    t.uuid "interest_payable_account_id"
    t.integer "balance_averaging_type"
    t.uuid "office_id"
    t.uuid "transfer_fee_account_id"
    t.decimal "transfer_fee"
    t.index ["cooperative_id"], name: "index_share_capital_products_on_cooperative_id"
    t.index ["equity_account_id"], name: "index_share_capital_products_on_equity_account_id"
    t.index ["interest_payable_account_id"], name: "index_share_capital_products_on_interest_payable_account_id"
    t.index ["name"], name: "index_share_capital_products_on_name"
    t.index ["office_id"], name: "index_share_capital_products_on_office_id"
    t.index ["transfer_fee_account_id"], name: "index_share_capital_products_on_transfer_fee_account_id"
  end

  create_table "share_capitals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "share_capital_product_id"
    t.string "account_number"
    t.datetime "date_opened"
    t.string "account_owner_name"
    t.datetime "created_at", default: "2019-12-04 03:49:02", null: false
    t.datetime "updated_at", default: "2019-12-04 03:49:02", null: false
    t.integer "status"
    t.uuid "office_id"
    t.string "subscriber_type"
    t.uuid "subscriber_id"
    t.boolean "has_minimum_balance", default: false
    t.uuid "cart_id"
    t.uuid "barangay_id"
    t.uuid "organization_id"
    t.uuid "cooperative_id"
    t.string "beneficiaries"
    t.string "maf_beneficiaries"
    t.string "code"
    t.uuid "equity_account_id"
    t.datetime "withdrawn_at"
    t.index ["account_number"], name: "index_share_capitals_on_account_number", unique: true
    t.index ["barangay_id"], name: "index_share_capitals_on_barangay_id"
    t.index ["cart_id"], name: "index_share_capitals_on_cart_id"
    t.index ["code"], name: "index_share_capitals_on_code", unique: true
    t.index ["cooperative_id"], name: "index_share_capitals_on_cooperative_id"
    t.index ["equity_account_id"], name: "index_share_capitals_on_equity_account_id"
    t.index ["office_id"], name: "index_share_capitals_on_office_id"
    t.index ["organization_id"], name: "index_share_capitals_on_organization_id"
    t.index ["share_capital_product_id"], name: "index_share_capitals_on_share_capital_product_id"
    t.index ["status"], name: "index_share_capitals_on_status"
    t.index ["subscriber_type", "subscriber_id"], name: "index_share_capitals_on_subscriber_type_and_subscriber_id"
  end

  create_table "stock_registries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_name"
    t.string "category_name"
    t.string "unit_of_measurement"
    t.decimal "in_stock"
    t.decimal "purchase_cost"
    t.decimal "total_cost"
    t.decimal "selling_cost"
    t.string "barcodes", default: [], array: true
    t.boolean "base_measurement"
    t.decimal "base_quantity"
    t.decimal "conversion_quantity"
    t.datetime "date"
    t.uuid "store_front_id"
    t.uuid "registry_id"
    t.uuid "employee_id"
    t.uuid "cooperative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_stock_registries_on_cooperative_id"
    t.index ["employee_id"], name: "index_stock_registries_on_employee_id"
    t.index ["registry_id"], name: "index_stock_registries_on_registry_id"
    t.index ["store_front_id"], name: "index_stock_registries_on_store_front_id"
  end

  create_table "stock_registry_temporary_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "product_name"
    t.string "category_name"
    t.string "unit_of_measurement"
    t.decimal "in_stock"
    t.decimal "purchase_cost"
    t.decimal "total_cost"
    t.decimal "selling_cost"
    t.string "barcodes", default: [], array: true
    t.boolean "base_measurement"
    t.decimal "base_quantity"
    t.decimal "conversion_quantity"
    t.uuid "store_front_id"
    t.uuid "cooperative_id"
    t.uuid "employee_id"
    t.uuid "stock_registry_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_stock_registry_temporary_products_on_cooperative_id"
    t.index ["employee_id"], name: "index_stock_registry_temporary_products_on_employee_id"
    t.index ["stock_registry_id"], name: "index_stock_registry_temporary_products_on_stock_registry_id"
    t.index ["store_front_id"], name: "index_stock_registry_temporary_products_on_store_front_id"
  end

  create_table "store_fronts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "receivable_account_id"
    t.uuid "cost_of_goods_sold_account_id"
    t.uuid "payable_account_id"
    t.uuid "merchandise_inventory_account_id"
    t.uuid "sales_account_id"
    t.uuid "sales_return_account_id"
    t.uuid "spoilage_account_id"
    t.uuid "sales_discount_account_id"
    t.uuid "purchase_return_account_id"
    t.uuid "internal_use_account_id"
    t.uuid "cooperative_service_id"
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_store_fronts_on_cooperative_id"
    t.index ["cooperative_service_id"], name: "index_store_fronts_on_cooperative_service_id"
    t.index ["cost_of_goods_sold_account_id"], name: "index_store_fronts_on_cost_of_goods_sold_account_id"
    t.index ["internal_use_account_id"], name: "index_store_fronts_on_internal_use_account_id"
    t.index ["merchandise_inventory_account_id"], name: "index_store_fronts_on_merchandise_inventory_account_id"
    t.index ["payable_account_id"], name: "index_store_fronts_on_payable_account_id"
    t.index ["purchase_return_account_id"], name: "index_store_fronts_on_purchase_return_account_id"
    t.index ["receivable_account_id"], name: "index_store_fronts_on_receivable_account_id"
    t.index ["sales_account_id"], name: "index_store_fronts_on_sales_account_id"
    t.index ["sales_discount_account_id"], name: "index_store_fronts_on_sales_discount_account_id"
    t.index ["sales_return_account_id"], name: "index_store_fronts_on_sales_return_account_id"
    t.index ["spoilage_account_id"], name: "index_store_fronts_on_spoilage_account_id"
  end

  create_table "streets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "barangay_id"
    t.uuid "municipality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barangay_id"], name: "index_streets_on_barangay_id"
    t.index ["municipality_id"], name: "index_streets_on_municipality_id"
    t.index ["name"], name: "index_streets_on_name"
  end

  create_table "suppliers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "contact_number"
    t.string "address"
    t.string "business_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.uuid "payable_account_id"
    t.index ["cooperative_id"], name: "index_suppliers_on_cooperative_id"
    t.index ["payable_account_id"], name: "index_suppliers_on_payable_account_id"
  end

  create_table "taggings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tag_id"
    t.string "taggable_type"
    t.uuid "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "termable_type"
    t.uuid "termable_id"
    t.datetime "effectivity_date"
    t.datetime "maturity_date"
    t.integer "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_days", default: 0
    t.index ["termable_type", "termable_id"], name: "index_terms_on_termable_type_and_termable_id"
  end

  create_table "time_deposit_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.string "account_number"
    t.datetime "date_deposited"
    t.decimal "term"
    t.decimal "amount"
    t.uuid "voucher_id"
    t.uuid "time_deposit_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cooperative_id"
    t.string "certificate_number"
    t.string "beneficiaries"
    t.uuid "liability_account_id"
    t.integer "number_of_days"
    t.uuid "office_id"
    t.index ["account_number"], name: "index_time_deposit_applications_on_account_number", unique: true
    t.index ["cooperative_id"], name: "index_time_deposit_applications_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_depositor_on_time_deposit_applications"
    t.index ["liability_account_id"], name: "index_time_deposit_applications_on_liability_account_id"
    t.index ["office_id"], name: "index_time_deposit_applications_on_office_id"
    t.index ["time_deposit_product_id"], name: "index_time_deposit_applications_on_time_deposit_product_id"
    t.index ["voucher_id"], name: "index_time_deposit_applications_on_voucher_id"
  end

  create_table "time_deposit_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "break_contract_account_id"
    t.uuid "interest_account_id"
    t.uuid "account_id"
    t.decimal "break_contract_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_time_deposit_configs_on_account_id"
    t.index ["break_contract_account_id"], name: "index_time_deposit_configs_on_break_contract_account_id"
    t.index ["interest_account_id"], name: "index_time_deposit_configs_on_interest_account_id"
  end

  create_table "time_deposit_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_days"
    t.integer "time_deposit_product_type"
    t.uuid "account_id"
    t.uuid "break_contract_account_id"
    t.uuid "interest_expense_account_id"
    t.decimal "break_contract_fee"
    t.decimal "minimum_deposit"
    t.decimal "maximum_deposit"
    t.decimal "break_contract_rate"
    t.uuid "cooperative_id"
    t.decimal "interest_rate"
    t.index ["account_id"], name: "index_time_deposit_products_on_account_id"
    t.index ["break_contract_account_id"], name: "index_time_deposit_products_on_break_contract_account_id"
    t.index ["cooperative_id"], name: "index_time_deposit_products_on_cooperative_id"
    t.index ["interest_expense_account_id"], name: "index_time_deposit_products_on_interest_expense_account_id"
    t.index ["name"], name: "index_time_deposit_products_on_name", unique: true
  end

  create_table "time_deposits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "time_deposit_product_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.uuid "office_id"
    t.uuid "membership_id"
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.datetime "date_deposited"
    t.datetime "last_transaction_date"
    t.string "depositor_name"
    t.uuid "cooperative_id"
    t.boolean "withdrawn", default: false
    t.uuid "organization_id"
    t.uuid "barangay_id"
    t.string "certificate_number"
    t.string "beneficiaries"
    t.string "code"
    t.uuid "liability_account_id"
    t.uuid "interest_expense_account_id"
    t.uuid "break_contract_account_id"
    t.index ["account_number"], name: "index_time_deposits_on_account_number", unique: true
    t.index ["barangay_id"], name: "index_time_deposits_on_barangay_id"
    t.index ["break_contract_account_id"], name: "index_time_deposits_on_break_contract_account_id"
    t.index ["code"], name: "index_time_deposits_on_code", unique: true
    t.index ["cooperative_id"], name: "index_time_deposits_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_time_deposits_on_depositor_type_and_depositor_id"
    t.index ["interest_expense_account_id"], name: "index_time_deposits_on_interest_expense_account_id"
    t.index ["liability_account_id"], name: "index_time_deposits_on_liability_account_id"
    t.index ["membership_id"], name: "index_time_deposits_on_membership_id"
    t.index ["office_id"], name: "index_time_deposits_on_office_id"
    t.index ["organization_id"], name: "index_time_deposits_on_organization_id"
    t.index ["status"], name: "index_time_deposits_on_status"
    t.index ["time_deposit_product_id"], name: "index_time_deposits_on_time_deposit_product_id"
  end

  create_table "tins", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number"
    t.string "tinable_type"
    t.uuid "tinable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tinable_type", "tinable_id"], name: "index_tins_on_tinable_type_and_tinable_id"
  end

  create_table "total_repayment_amortizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "calculation_type", null: false
    t.index ["calculation_type"], name: "index_total_repayment_amortizations_on_calculation_type"
  end

  create_table "unit_of_measurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.string "code"
    t.string "description"
    t.boolean "base_measurement", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "base_quantity"
    t.decimal "conversion_quantity", default: "1.0"
    t.index ["product_id"], name: "index_unit_of_measurements_on_product_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.date "date_of_birth"
    t.integer "sex"
    t.uuid "cooperative_id"
    t.date "date_or_birth"
    t.integer "birth_month"
    t.integer "birth_day"
    t.uuid "office_id"
    t.uuid "store_front_id"
    t.string "designation"
    t.datetime "last_transaction_date"
    t.index ["cooperative_id"], name: "index_users_on_cooperative_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["office_id"], name: "index_users_on_office_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["store_front_id"], name: "index_users_on_store_front_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "voucher_amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "PHP", null: false
    t.uuid "account_id"
    t.uuid "voucher_id"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "amount_type", default: 0
    t.uuid "recorder_id"
    t.uuid "cooperative_id"
    t.uuid "loan_application_id"
    t.string "reference_number"
    t.uuid "cart_id"
    t.string "temp_cart_type"
    t.uuid "temp_cart_id"
    t.index ["account_id"], name: "index_voucher_amounts_on_account_id"
    t.index ["amount_type"], name: "index_voucher_amounts_on_amount_type"
    t.index ["cart_id"], name: "index_voucher_amounts_on_cart_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_voucher_amount"
    t.index ["cooperative_id"], name: "index_voucher_amounts_on_cooperative_id"
    t.index ["loan_application_id"], name: "index_voucher_amounts_on_loan_application_id"
    t.index ["recorder_id"], name: "index_voucher_amounts_on_recorder_id"
    t.index ["temp_cart_type", "temp_cart_id"], name: "index_voucher_amounts_on_temp_cart_type_and_temp_cart_id"
    t.index ["voucher_id"], name: "index_voucher_amounts_on_voucher_id"
  end

  create_table "vouchers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number"
    t.datetime "date"
    t.string "payee_type"
    t.uuid "payee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.decimal "payable_amount"
    t.uuid "preparer_id"
    t.uuid "disburser_id"
    t.boolean "unearned", default: false
    t.string "token"
    t.uuid "entry_id"
    t.uuid "office_id"
    t.uuid "cooperative_id"
    t.string "account_number"
    t.uuid "cooperative_service_id"
    t.string "reference_number"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.uuid "store_front_id"
    t.datetime "cancelled_at"
    t.datetime "date_prepared"
    t.datetime "disbursement_date"
    t.string "recording_agent_type"
    t.uuid "recording_agent_id"
    t.string "origin_type"
    t.uuid "origin_id"
    t.string "disbursing_agent_type"
    t.uuid "disbursing_agent_id"
    t.index ["account_number"], name: "index_vouchers_on_account_number", unique: true
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_vouchers"
    t.index ["cooperative_id"], name: "index_vouchers_on_cooperative_id"
    t.index ["cooperative_service_id"], name: "index_vouchers_on_cooperative_service_id"
    t.index ["disburser_id"], name: "index_vouchers_on_disburser_id"
    t.index ["disbursing_agent_type", "disbursing_agent_id"], name: "index_vouchers_on_disbursing_agent_type_and_disbursing_agent_id"
    t.index ["entry_id"], name: "index_vouchers_on_entry_id"
    t.index ["office_id"], name: "index_vouchers_on_office_id"
    t.index ["origin_type", "origin_id"], name: "index_vouchers_on_origin_type_and_origin_id"
    t.index ["payee_type", "payee_id"], name: "index_vouchers_on_payee_type_and_payee_id"
    t.index ["preparer_id"], name: "index_vouchers_on_preparer_id"
    t.index ["recording_agent_type", "recording_agent_id"], name: "index_vouchers_on_recording_agent_type_and_recording_agent_id"
    t.index ["store_front_id"], name: "index_vouchers_on_store_front_id"
    t.index ["token"], name: "index_vouchers_on_token"
  end

  create_table "wallets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "account_owner_type"
    t.uuid "account_owner_id"
    t.uuid "account_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_wallets_on_account_id"
    t.index ["account_number"], name: "index_wallets_on_account_number", unique: true
    t.index ["account_owner_type", "account_owner_id"], name: "index_wallets_on_account_owner_type_and_account_owner_id"
  end

  add_foreign_key "account_budgets", "accounts"
  add_foreign_key "account_budgets", "cooperatives"
  add_foreign_key "accountable_accounts", "accounts"
  add_foreign_key "accounting_report_account_categorizations", "accounting_reports"
  add_foreign_key "accounting_reports", "offices"
  add_foreign_key "accounts", "level_one_account_categories"
  add_foreign_key "addresses", "barangays"
  add_foreign_key "addresses", "municipalities"
  add_foreign_key "addresses", "provinces"
  add_foreign_key "addresses", "streets"
  add_foreign_key "amortization_schedules", "accounts", column: "credit_account_id"
  add_foreign_key "amortization_schedules", "accounts", column: "debit_account_id"
  add_foreign_key "amortization_schedules", "cooperatives"
  add_foreign_key "amortization_schedules", "loan_applications"
  add_foreign_key "amortization_schedules", "loans"
  add_foreign_key "amortization_schedules", "offices"
  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "archives", "users", column: "archiver_id"
  add_foreign_key "bank_accounts", "accounts", column: "cash_account_id"
  add_foreign_key "bank_accounts", "accounts", column: "interest_revenue_account_id"
  add_foreign_key "bank_accounts", "cooperatives"
  add_foreign_key "bank_accounts", "offices"
  add_foreign_key "banking_agent_carts", "banking_agents"
  add_foreign_key "banking_agents", "accounts", column: "cash_account_id"
  add_foreign_key "banking_agents", "accounts", column: "depository_account_id"
  add_foreign_key "barangays", "cooperatives"
  add_foreign_key "barangays", "municipalities"
  add_foreign_key "barcodes", "line_items"
  add_foreign_key "beneficiaries", "cooperatives"
  add_foreign_key "beneficiaries", "members"
  add_foreign_key "carts", "users"
  add_foreign_key "cash_count_reports", "users", column: "employee_id"
  add_foreign_key "cash_counts", "bills"
  add_foreign_key "cash_counts", "carts"
  add_foreign_key "cash_counts", "cash_count_reports"
  add_foreign_key "categories", "cooperatives"
  add_foreign_key "clearing_house_depository_accounts", "accounts", column: "depository_account_id"
  add_foreign_key "clearing_house_depository_accounts", "automated_clearing_houses", column: "clearing_house_id"
  add_foreign_key "cooperative_banking_agents", "banking_agents"
  add_foreign_key "cooperative_banking_agents", "cooperatives"
  add_foreign_key "cooperative_services", "cooperatives"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "credit_account_id"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "debit_account_id"
  add_foreign_key "employee_cash_accounts", "accounts", column: "cash_account_id"
  add_foreign_key "employee_cash_accounts", "cooperatives"
  add_foreign_key "employee_cash_accounts", "users", column: "employee_id"
  add_foreign_key "entries", "cooperative_services"
  add_foreign_key "entries", "cooperatives"
  add_foreign_key "entries", "entries", column: "cancellation_entry_id"
  add_foreign_key "entries", "offices"
  add_foreign_key "entries", "official_receipts"
  add_foreign_key "entries", "users", column: "cancelled_by_id"
  add_foreign_key "entries", "users", column: "recorder_id"
  add_foreign_key "identifications", "identifications", column: "previous_identification_id"
  add_foreign_key "identifications", "identity_providers"
  add_foreign_key "income_sources", "income_source_categories"
  add_foreign_key "income_sources", "members"
  add_foreign_key "interest_configs", "accounts", column: "accrued_income_account_id"
  add_foreign_key "interest_configs", "accounts", column: "interest_revenue_account_id"
  add_foreign_key "interest_configs", "accounts", column: "past_due_interest_income_account_id"
  add_foreign_key "interest_configs", "accounts", column: "unearned_interest_income_account_id"
  add_foreign_key "interest_configs", "cooperatives"
  add_foreign_key "interest_configs", "loan_products"
  add_foreign_key "interest_predeductions", "loan_products"
  add_foreign_key "level_four_account_categories", "offices"
  add_foreign_key "level_one_account_categories", "level_two_account_categories"
  add_foreign_key "level_one_account_categories", "offices"
  add_foreign_key "level_three_account_categories", "level_four_account_categories"
  add_foreign_key "level_three_account_categories", "offices"
  add_foreign_key "level_two_account_categories", "level_three_account_categories"
  add_foreign_key "level_two_account_categories", "offices"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "line_items", column: "referenced_line_item_id"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "unit_of_measurements"
  add_foreign_key "loan_aging_groups", "level_two_account_categories"
  add_foreign_key "loan_aging_groups", "offices"
  add_foreign_key "loan_agings", "accounts", column: "receivable_account_id"
  add_foreign_key "loan_agings", "loan_aging_groups"
  add_foreign_key "loan_agings", "loans"
  add_foreign_key "loan_applications", "accounts", column: "interest_revenue_account_id"
  add_foreign_key "loan_applications", "accounts", column: "receivable_account_id"
  add_foreign_key "loan_applications", "carts"
  add_foreign_key "loan_applications", "cooperatives"
  add_foreign_key "loan_applications", "loan_products"
  add_foreign_key "loan_applications", "offices"
  add_foreign_key "loan_applications", "organizations"
  add_foreign_key "loan_applications", "users", column: "preparer_id"
  add_foreign_key "loan_applications", "vouchers"
  add_foreign_key "loan_charge_payment_schedules", "amortization_schedules"
  add_foreign_key "loan_charge_payment_schedules", "loans"
  add_foreign_key "loan_co_makers", "loans"
  add_foreign_key "loan_discounts", "loans"
  add_foreign_key "loan_discounts", "users", column: "computed_by_id"
  add_foreign_key "loan_interests", "loans"
  add_foreign_key "loan_interests", "users", column: "computed_by_id"
  add_foreign_key "loan_penalties", "loans"
  add_foreign_key "loan_penalties", "users", column: "computed_by_id"
  add_foreign_key "loan_product_charges", "accounts"
  add_foreign_key "loan_product_charges", "loan_products"
  add_foreign_key "loan_products", "accounts", column: "current_account_id"
  add_foreign_key "loan_products", "accounts", column: "litigation_account_id"
  add_foreign_key "loan_products", "accounts", column: "past_due_account_id"
  add_foreign_key "loan_products", "accounts", column: "restructured_account_id"
  add_foreign_key "loan_products", "amortization_types"
  add_foreign_key "loan_products", "cooperatives"
  add_foreign_key "loan_products", "interest_amortizations"
  add_foreign_key "loan_products", "loan_protection_plan_providers"
  add_foreign_key "loan_products", "offices"
  add_foreign_key "loan_products", "total_repayment_amortizations"
  add_foreign_key "loan_protection_plan_providers", "accounts", column: "accounts_payable_id"
  add_foreign_key "loan_protection_plan_providers", "cooperatives"
  add_foreign_key "loans", "accounts", column: "accrued_income_account_id"
  add_foreign_key "loans", "accounts", column: "interest_revenue_account_id"
  add_foreign_key "loans", "accounts", column: "penalty_revenue_account_id"
  add_foreign_key "loans", "accounts", column: "receivable_account_id"
  add_foreign_key "loans", "barangays"
  add_foreign_key "loans", "cooperatives"
  add_foreign_key "loans", "loan_aging_groups"
  add_foreign_key "loans", "loan_applications"
  add_foreign_key "loans", "loan_products"
  add_foreign_key "loans", "municipalities"
  add_foreign_key "loans", "offices"
  add_foreign_key "loans", "organizations"
  add_foreign_key "loans", "streets"
  add_foreign_key "loans", "users", column: "archived_by_id"
  add_foreign_key "loans", "users", column: "preparer_id"
  add_foreign_key "loans", "vouchers"
  add_foreign_key "loans", "vouchers", column: "disbursement_voucher_id"
  add_foreign_key "mark_up_prices", "unit_of_measurements"
  add_foreign_key "member_occupations", "members"
  add_foreign_key "member_occupations", "occupations"
  add_foreign_key "members", "carts"
  add_foreign_key "membership_beneficiaries", "memberships"
  add_foreign_key "membership_categories", "cooperatives"
  add_foreign_key "memberships", "cooperatives"
  add_foreign_key "memberships", "membership_categories"
  add_foreign_key "memberships", "offices"
  add_foreign_key "merchants", "accounts", column: "liability_account_id"
  add_foreign_key "merchants", "cooperatives"
  add_foreign_key "municipalities", "cooperatives"
  add_foreign_key "municipalities", "provinces"
  add_foreign_key "net_income_configs", "accounts", column: "interest_on_capital_account_id"
  add_foreign_key "net_income_configs", "accounts", column: "net_loss_account_id"
  add_foreign_key "net_income_configs", "accounts", column: "net_surplus_account_id"
  add_foreign_key "net_income_configs", "accounts", column: "total_expense_account_id"
  add_foreign_key "net_income_configs", "accounts", column: "total_revenue_account_id"
  add_foreign_key "net_income_configs", "offices"
  add_foreign_key "net_income_distributions", "accounts"
  add_foreign_key "net_income_distributions", "cooperatives"
  add_foreign_key "notes", "users", column: "noter_id"
  add_foreign_key "office_loan_product_aging_groups", "level_one_account_categories"
  add_foreign_key "office_loan_product_aging_groups", "loan_aging_groups"
  add_foreign_key "office_loan_product_aging_groups", "office_loan_products"
  add_foreign_key "office_loan_products", "accounts", column: "forwarding_account_id"
  add_foreign_key "office_loan_products", "level_one_account_categories", column: "interest_revenue_account_category_id"
  add_foreign_key "office_loan_products", "level_one_account_categories", column: "penalty_revenue_account_category_id"
  add_foreign_key "office_loan_products", "loan_products"
  add_foreign_key "office_loan_products", "loan_protection_plan_providers"
  add_foreign_key "office_loan_products", "offices"
  add_foreign_key "office_programs", "level_one_account_categories"
  add_foreign_key "office_programs", "offices"
  add_foreign_key "office_programs", "programs"
  add_foreign_key "office_saving_products", "accounts", column: "forwarding_account_id"
  add_foreign_key "office_saving_products", "level_one_account_categories", column: "closing_account_category_id"
  add_foreign_key "office_saving_products", "level_one_account_categories", column: "interest_expense_account_category_id"
  add_foreign_key "office_saving_products", "level_one_account_categories", column: "liability_account_category_id"
  add_foreign_key "office_saving_products", "offices"
  add_foreign_key "office_saving_products", "saving_products"
  add_foreign_key "office_share_capital_products", "accounts", column: "forwarding_account_id"
  add_foreign_key "office_share_capital_products", "level_one_account_categories", column: "equity_account_category_id"
  add_foreign_key "office_share_capital_products", "offices"
  add_foreign_key "office_share_capital_products", "share_capital_products"
  add_foreign_key "office_time_deposit_products", "accounts", column: "forwarding_account_id"
  add_foreign_key "office_time_deposit_products", "level_one_account_categories", column: "break_contract_account_category_id"
  add_foreign_key "office_time_deposit_products", "level_one_account_categories", column: "interest_expense_account_category_id"
  add_foreign_key "office_time_deposit_products", "level_one_account_categories", column: "liability_account_category_id"
  add_foreign_key "office_time_deposit_products", "offices"
  add_foreign_key "office_time_deposit_products", "time_deposit_products"
  add_foreign_key "offices", "cooperatives"
  add_foreign_key "orders", "cooperatives"
  add_foreign_key "orders", "store_fronts"
  add_foreign_key "orders", "store_fronts", column: "destination_store_front_id"
  add_foreign_key "orders", "users", column: "employee_id"
  add_foreign_key "orders", "vouchers"
  add_foreign_key "organization_members", "organizations"
  add_foreign_key "organization_scopes", "organizations"
  add_foreign_key "organizations", "cooperatives"
  add_foreign_key "penalty_configs", "accounts", column: "penalty_revenue_account_id"
  add_foreign_key "penalty_configs", "cooperatives"
  add_foreign_key "penalty_configs", "loan_products"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "cooperatives"
  add_foreign_key "products", "store_fronts"
  add_foreign_key "program_subscriptions", "accounts"
  add_foreign_key "program_subscriptions", "offices"
  add_foreign_key "program_subscriptions", "programs"
  add_foreign_key "programs", "accounts"
  add_foreign_key "programs", "cooperatives"
  add_foreign_key "programs", "level_one_account_categories"
  add_foreign_key "registries", "cooperatives"
  add_foreign_key "registries", "offices"
  add_foreign_key "registries", "store_fronts"
  add_foreign_key "registries", "suppliers"
  add_foreign_key "registries", "users", column: "employee_id"
  add_foreign_key "sales_purchase_line_items", "line_items", column: "purchase_line_item_id"
  add_foreign_key "sales_purchase_line_items", "line_items", column: "sales_line_item_id"
  add_foreign_key "saving_product_interest_configs", "level_one_account_categories", column: "interest_expense_category_id"
  add_foreign_key "saving_product_interest_configs", "saving_products"
  add_foreign_key "saving_products", "accounts"
  add_foreign_key "saving_products", "accounts", column: "closing_account_id"
  add_foreign_key "saving_products", "accounts", column: "interest_expense_account_id"
  add_foreign_key "saving_products", "cooperatives"
  add_foreign_key "saving_products", "offices"
  add_foreign_key "savings", "accounts", column: "interest_expense_account_id"
  add_foreign_key "savings", "accounts", column: "liability_account_id"
  add_foreign_key "savings", "barangays"
  add_foreign_key "savings", "cooperatives"
  add_foreign_key "savings", "offices"
  add_foreign_key "savings", "organizations"
  add_foreign_key "savings", "saving_products"
  add_foreign_key "savings_account_agings", "savings", column: "savings_account_id"
  add_foreign_key "savings_account_agings", "savings_aging_groups"
  add_foreign_key "savings_account_applications", "accounts", column: "liability_account_id"
  add_foreign_key "savings_account_applications", "cooperatives"
  add_foreign_key "savings_account_applications", "offices"
  add_foreign_key "savings_account_applications", "saving_products"
  add_foreign_key "savings_aging_groups", "offices"
  add_foreign_key "share_capital_applications", "accounts", column: "equity_account_id"
  add_foreign_key "share_capital_applications", "cooperatives"
  add_foreign_key "share_capital_applications", "offices"
  add_foreign_key "share_capital_applications", "share_capital_products"
  add_foreign_key "share_capital_products", "accounts", column: "equity_account_id"
  add_foreign_key "share_capital_products", "accounts", column: "interest_payable_account_id"
  add_foreign_key "share_capital_products", "accounts", column: "transfer_fee_account_id"
  add_foreign_key "share_capital_products", "cooperatives"
  add_foreign_key "share_capital_products", "offices"
  add_foreign_key "share_capitals", "accounts", column: "equity_account_id"
  add_foreign_key "share_capitals", "barangays"
  add_foreign_key "share_capitals", "carts"
  add_foreign_key "share_capitals", "cooperatives"
  add_foreign_key "share_capitals", "offices"
  add_foreign_key "share_capitals", "organizations"
  add_foreign_key "share_capitals", "share_capital_products"
  add_foreign_key "stock_registries", "cooperatives"
  add_foreign_key "stock_registries", "registries"
  add_foreign_key "stock_registries", "store_fronts"
  add_foreign_key "stock_registries", "users", column: "employee_id"
  add_foreign_key "stock_registry_temporary_products", "cooperatives"
  add_foreign_key "stock_registry_temporary_products", "registries", column: "stock_registry_id"
  add_foreign_key "stock_registry_temporary_products", "store_fronts"
  add_foreign_key "stock_registry_temporary_products", "users", column: "employee_id"
  add_foreign_key "store_fronts", "accounts", column: "cost_of_goods_sold_account_id"
  add_foreign_key "store_fronts", "accounts", column: "internal_use_account_id"
  add_foreign_key "store_fronts", "accounts", column: "merchandise_inventory_account_id"
  add_foreign_key "store_fronts", "accounts", column: "payable_account_id"
  add_foreign_key "store_fronts", "accounts", column: "purchase_return_account_id"
  add_foreign_key "store_fronts", "accounts", column: "receivable_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_discount_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_return_account_id"
  add_foreign_key "store_fronts", "accounts", column: "spoilage_account_id"
  add_foreign_key "store_fronts", "cooperative_services"
  add_foreign_key "store_fronts", "cooperatives"
  add_foreign_key "streets", "barangays"
  add_foreign_key "streets", "municipalities"
  add_foreign_key "suppliers", "accounts", column: "payable_account_id"
  add_foreign_key "suppliers", "cooperatives"
  add_foreign_key "taggings", "tags"
  add_foreign_key "time_deposit_applications", "accounts", column: "liability_account_id"
  add_foreign_key "time_deposit_applications", "cooperatives"
  add_foreign_key "time_deposit_applications", "offices"
  add_foreign_key "time_deposit_applications", "time_deposit_products"
  add_foreign_key "time_deposit_applications", "vouchers"
  add_foreign_key "time_deposit_configs", "accounts"
  add_foreign_key "time_deposit_configs", "accounts", column: "break_contract_account_id"
  add_foreign_key "time_deposit_configs", "accounts", column: "interest_account_id"
  add_foreign_key "time_deposit_products", "accounts"
  add_foreign_key "time_deposit_products", "accounts", column: "break_contract_account_id"
  add_foreign_key "time_deposit_products", "accounts", column: "interest_expense_account_id"
  add_foreign_key "time_deposit_products", "cooperatives"
  add_foreign_key "time_deposits", "accounts", column: "break_contract_account_id"
  add_foreign_key "time_deposits", "accounts", column: "interest_expense_account_id"
  add_foreign_key "time_deposits", "accounts", column: "liability_account_id"
  add_foreign_key "time_deposits", "barangays"
  add_foreign_key "time_deposits", "cooperatives"
  add_foreign_key "time_deposits", "memberships"
  add_foreign_key "time_deposits", "offices"
  add_foreign_key "time_deposits", "organizations"
  add_foreign_key "time_deposits", "time_deposit_products"
  add_foreign_key "unit_of_measurements", "products"
  add_foreign_key "users", "cooperatives"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "store_fronts"
  add_foreign_key "voucher_amounts", "accounts"
  add_foreign_key "voucher_amounts", "carts"
  add_foreign_key "voucher_amounts", "cooperatives"
  add_foreign_key "voucher_amounts", "loan_applications"
  add_foreign_key "voucher_amounts", "users", column: "recorder_id"
  add_foreign_key "voucher_amounts", "vouchers"
  add_foreign_key "vouchers", "cooperative_services"
  add_foreign_key "vouchers", "cooperatives"
  add_foreign_key "vouchers", "entries"
  add_foreign_key "vouchers", "offices"
  add_foreign_key "vouchers", "store_fronts"
  add_foreign_key "vouchers", "users", column: "disburser_id"
  add_foreign_key "vouchers", "users", column: "preparer_id"
  add_foreign_key "wallets", "accounts"
end
