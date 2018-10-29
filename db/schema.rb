# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_27_083012) do

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

  create_table "accountable_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "accountable_type"
    t.uuid "accountable_id"
    t.uuid "account_id"
    t.index ["account_id"], name: "index_accountable_accounts_on_account_id"
    t.index ["accountable_type", "accountable_id"], name: "index_accountable_on_accountable_accounts"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "contra", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "main_account_id"
    t.boolean "active", default: true
    t.datetime "last_transaction_date"
    t.index ["code"], name: "index_accounts_on_code", unique: true
    t.index ["main_account_id"], name: "index_accounts_on_main_account_id"
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["type"], name: "index_accounts_on_type"
    t.index ["updated_at"], name: "index_accounts_on_updated_at"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
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
    t.boolean "has_prededucted_interest"
    t.boolean "prededucted_interest", default: false
    t.uuid "debit_account_id"
    t.uuid "credit_account_id"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.integer "payment_status"
    t.uuid "loan_application_id"
    t.decimal "principal", default: "0.0"
    t.decimal "interest", default: "0.0"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_amortization_schedules"
    t.index ["credit_account_id"], name: "index_amortization_schedules_on_credit_account_id"
    t.index ["debit_account_id"], name: "index_amortization_schedules_on_debit_account_id"
    t.index ["loan_application_id"], name: "index_amortization_schedules_on_loan_application_id"
    t.index ["loan_id"], name: "index_amortization_schedules_on_loan_id"
    t.index ["payment_status"], name: "index_amortization_schedules_on_payment_status"
    t.index ["schedule_type"], name: "index_amortization_schedules_on_schedule_type"
  end

  create_table "amount_adjustments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "voucher_amount_id"
    t.uuid "loan_application_id"
    t.decimal "amount"
    t.decimal "percent"
    t.integer "number_of_payments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_application_id"], name: "index_amount_adjustments_on_loan_application_id"
    t.index ["voucher_amount_id"], name: "index_amount_adjustments_on_voucher_amount_id"
  end

  create_table "amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "entry_id"
    t.decimal "amount"
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

  create_table "bank_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "bank_name"
    t.string "bank_address"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.uuid "earned_interest_account_id"
    t.index ["account_id"], name: "index_bank_accounts_on_account_id"
    t.index ["cooperative_id"], name: "index_bank_accounts_on_cooperative_id"
    t.index ["earned_interest_account_id"], name: "index_bank_accounts_on_earned_interest_account_id"
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

  create_table "beneficiaries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.string "full_name"
    t.string "relationship"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_beneficiaries_on_member_id"
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "charge_adjustments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_charge_id"
    t.decimal "amount"
    t.decimal "percent"
    t.boolean "amortize_balance", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_payments"
    t.index ["loan_charge_id"], name: "index_charge_adjustments_on_loan_charge_id"
  end

  create_table "charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "charge_type"
    t.decimal "amount"
    t.decimal "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.decimal "minimum_loan_amount"
    t.decimal "maximum_loan_amount"
    t.boolean "depends_on_loan_amount", default: false
    t.index ["account_id"], name: "index_charges_on_account_id"
    t.index ["charge_type"], name: "index_charges_on_charge_type"
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
    t.uuid "interest_amortization_config_id"
    t.index ["abbreviated_name"], name: "index_cooperatives_on_abbreviated_name", unique: true
    t.index ["interest_amortization_config_id"], name: "index_cooperatives_on_interest_amortization_config_id"
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
    t.index ["cash_account_id"], name: "index_employee_cash_accounts_on_cash_account_id"
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
    t.uuid "previous_entry_id"
    t.string "previous_entry_hash"
    t.string "encrypted_hash"
    t.index ["cancelled_by_id"], name: "index_entries_on_cancelled_by_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
    t.index ["cooperative_id"], name: "index_entries_on_cooperative_id"
    t.index ["cooperative_service_id"], name: "index_entries_on_cooperative_service_id"
    t.index ["encrypted_hash"], name: "index_entries_on_encrypted_hash", unique: true
    t.index ["entry_date"], name: "index_entries_on_entry_date"
    t.index ["office_id"], name: "index_entries_on_office_id"
    t.index ["official_receipt_id"], name: "index_entries_on_official_receipt_id"
    t.index ["previous_entry_hash"], name: "index_entries_on_previous_entry_hash", unique: true
    t.index ["previous_entry_id"], name: "index_entries_on_previous_entry_id"
    t.index ["recorder_id"], name: "index_entries_on_recorder_id"
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

  create_table "interest_amortization_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "amortization_type"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amortization_type"], name: "index_interest_amortization_configs_on_amortization_type"
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
    t.index ["calculation_type"], name: "index_interest_configs_on_calculation_type"
    t.index ["cooperative_id"], name: "index_interest_configs_on_cooperative_id"
    t.index ["interest_revenue_account_id"], name: "index_interest_configs_on_interest_revenue_account_id"
    t.index ["interest_type"], name: "index_interest_configs_on_interest_type"
    t.index ["loan_product_id"], name: "index_interest_configs_on_loan_product_id"
    t.index ["prededuction_type"], name: "index_interest_configs_on_prededuction_type"
    t.index ["unearned_interest_income_account_id"], name: "index_interest_configs_on_unearned_interest_income_account_id"
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

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "order_id"
    t.uuid "cart_id"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.decimal "quantity"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "unit_of_measurement_id"
    t.string "type"
    t.string "barcode"
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

  create_table "loan_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "borrower_type"
    t.uuid "borrower_id"
    t.integer "term"
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
    t.index ["borrower_type", "borrower_id"], name: "index_loan_applications_on_borrower_type_and_borrower_id"
    t.index ["cooperative_id"], name: "index_loan_applications_on_cooperative_id"
    t.index ["loan_product_id"], name: "index_loan_applications_on_loan_product_id"
    t.index ["office_id"], name: "index_loan_applications_on_office_id"
    t.index ["organization_id"], name: "index_loan_applications_on_organization_id"
    t.index ["preparer_id"], name: "index_loan_applications_on_preparer_id"
  end

  create_table "loan_charge_payment_schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_charge_id"
    t.integer "schedule_type"
    t.datetime "date"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "amortization_schedule_id"
    t.uuid "loan_id"
    t.index ["amortization_schedule_id"], name: "index_loan_charge_payment_schedules_on_amortization_schedule_id"
    t.index ["loan_charge_id"], name: "index_loan_charge_payment_schedules_on_loan_charge_id"
    t.index ["loan_id"], name: "index_loan_charge_payment_schedules_on_loan_id"
    t.index ["schedule_type"], name: "index_loan_charge_payment_schedules_on_schedule_type"
  end

  create_table "loan_charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.boolean "optional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.integer "amount_type"
    t.uuid "charge_id"
    t.index ["amount_type"], name: "index_loan_charges_on_amount_type"
    t.index ["charge_id"], name: "index_loan_charges_on_charge_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_loan_charges"
    t.index ["loan_id"], name: "index_loan_charges_on_loan_id"
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
    t.uuid "charge_id"
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_loan_product_charges_on_charge_id"
    t.index ["loan_product_id"], name: "index_loan_product_charges_on_loan_product_id"
  end

  create_table "loan_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.decimal "maximum_loanable_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.decimal "minimum_loanable_amount"
    t.string "depends_on_share_capital_balance"
    t.decimal "minimum_share_capital_balance"
    t.decimal "maximum_share_capital_balance"
    t.string "slug"
    t.uuid "loans_receivable_current_account_id"
    t.uuid "loans_receivable_past_due_account_id"
    t.uuid "cooperative_id"
    t.boolean "has_loan_protection_fund"
    t.index ["cooperative_id"], name: "index_loan_products_on_cooperative_id"
    t.index ["loans_receivable_current_account_id"], name: "index_loan_products_on_loans_receivable_current_account_id"
    t.index ["loans_receivable_past_due_account_id"], name: "index_loan_products_on_loans_receivable_past_due_account_id"
    t.index ["name"], name: "index_loan_products_on_name", unique: true
    t.index ["slug"], name: "index_loan_products_on_slug", unique: true
  end

  create_table "loan_protection_funds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "rate"
    t.string "name"
    t.integer "computation_type"
    t.uuid "cooperative_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["computation_type"], name: "index_loan_protection_funds_on_computation_type"
    t.index ["cooperative_id"], name: "index_loan_protection_funds_on_cooperative_id"
  end

  create_table "loan_protection_plan_providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "account_id"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_loan_protection_plan_providers_on_account_id"
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
    t.index ["account_number"], name: "index_loans_on_account_number", unique: true
    t.index ["archived_by_id"], name: "index_loans_on_archived_by_id"
    t.index ["barangay_id"], name: "index_loans_on_barangay_id"
    t.index ["borrower_type", "borrower_id"], name: "index_loans_on_borrower_type_and_borrower_id"
    t.index ["cooperative_id"], name: "index_loans_on_cooperative_id"
    t.index ["disbursement_voucher_id"], name: "index_loans_on_disbursement_voucher_id"
    t.index ["loan_product_id"], name: "index_loans_on_loan_product_id"
    t.index ["municipality_id"], name: "index_loans_on_municipality_id"
    t.index ["office_id"], name: "index_loans_on_office_id"
    t.index ["organization_id"], name: "index_loans_on_organization_id"
    t.index ["preparer_id"], name: "index_loans_on_preparer_id"
    t.index ["street_id"], name: "index_loans_on_street_id"
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
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "slug"
    t.integer "birth_month"
    t.integer "birth_day"
    t.string "email", default: "", null: false
    t.uuid "office_id"
    t.integer "birth_year"
    t.datetime "last_transaction_date"
    t.uuid "cart_id"
    t.string "account_number"
    t.index ["account_number"], name: "index_members_on_account_number", unique: true
    t.index ["cart_id"], name: "index_members_on_cart_id"
    t.index ["office_id"], name: "index_members_on_office_id"
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

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "membership_date"
    t.uuid "cooperative_id"
    t.integer "membership_type"
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
    t.index ["account_number"], name: "index_memberships_on_account_number", unique: true
    t.index ["beneficiary_type", "beneficiary_id"], name: "index_memberships_on_beneficiary_type_and_beneficiary_id"
    t.index ["cooperative_id"], name: "index_memberships_on_cooperative_id"
    t.index ["cooperator_type", "cooperator_id"], name: "index_memberships_on_cooperator_type_and_cooperator_id"
    t.index ["membership_type"], name: "index_memberships_on_membership_type"
    t.index ["status"], name: "index_memberships_on_status"
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

  create_table "offices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.uuid "cooperative_id"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "cash_in_vault_account_id"
    t.index ["cash_in_vault_account_id"], name: "index_offices_on_cash_in_vault_account_id"
    t.index ["cooperative_id"], name: "index_offices_on_cooperative_id"
    t.index ["type"], name: "index_offices_on_type"
  end

  create_table "official_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number", null: false
    t.string "receiptable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_commercial_document_on_orders"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["pay_type"], name: "index_orders_on_pay_type"
    t.index ["store_front_id"], name: "index_orders_on_store_front_id"
    t.index ["type"], name: "index_orders_on_type"
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

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "last_transaction_date"
    t.uuid "cooperative_id"
    t.string "abbreviated_name"
    t.index ["cooperative_id"], name: "index_organizations_on_cooperative_id"
  end

  create_table "ownerships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "owner_id"
    t.string "ownable_type"
    t.uuid "ownable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ownable_type", "ownable_id"], name: "index_ownerships_on_ownable_type_and_ownable_id"
    t.index ["owner_id"], name: "index_ownerships_on_owner_id"
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
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.bigint "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "name"
    t.uuid "category_id"
    t.string "unit_of_measurement"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "program_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscriber_type"
    t.uuid "subscriber_id"
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
    t.index ["account_id"], name: "index_programs_on_account_id"
    t.index ["cooperative_id"], name: "index_programs_on_cooperative_id"
    t.index ["payment_schedule_type"], name: "index_programs_on_payment_schedule_type"
  end

  create_table "provinces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_provinces_on_name", unique: true
  end

  create_table "registries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.string "spreadsheet_file_name"
    t.string "spreadsheet_content_type"
    t.bigint "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "supplier_id"
    t.string "number"
    t.uuid "employee_id"
    t.index ["employee_id"], name: "index_registries_on_employee_id"
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
    t.index ["account_id"], name: "index_saving_products_on_account_id"
    t.index ["closing_account_id"], name: "index_saving_products_on_closing_account_id"
    t.index ["cooperative_id"], name: "index_saving_products_on_cooperative_id"
    t.index ["interest_expense_account_id"], name: "index_saving_products_on_interest_expense_account_id"
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
    t.datetime "last_transaction_date"
    t.uuid "cart_id"
    t.uuid "cooperative_id"
    t.boolean "archived"
    t.datetime "archived_at"
    t.index ["account_number"], name: "index_savings_on_account_number", unique: true
    t.index ["account_owner_name"], name: "index_savings_on_account_owner_name"
    t.index ["barangay_id"], name: "index_savings_on_barangay_id"
    t.index ["cart_id"], name: "index_savings_on_cart_id"
    t.index ["cooperative_id"], name: "index_savings_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_savings_on_depositor_type_and_depositor_id"
    t.index ["office_id"], name: "index_savings_on_office_id"
    t.index ["saving_product_id"], name: "index_savings_on_saving_product_id"
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
    t.index ["depositor_type", "depositor_id"], name: "index_depositor_on_savings_account_applications"
    t.index ["saving_product_id"], name: "index_savings_account_applications_on_saving_product_id"
  end

  create_table "savings_account_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "closing_account_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "closing_account_id"
    t.decimal "number_of_days_to_be_dormant"
    t.uuid "interest_expense_account_id"
    t.index ["closing_account_id"], name: "index_savings_account_configs_on_closing_account_id"
    t.index ["interest_expense_account_id"], name: "index_savings_account_configs_on_interest_expense_account_id"
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
    t.index ["cooperative_id"], name: "index_share_capital_applications_on_cooperative_id"
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
    t.uuid "paid_up_account_id"
    t.uuid "subscription_account_id"
    t.decimal "cost_per_share"
    t.boolean "has_closing_account_fee", default: false
    t.decimal "closing_account_fee", default: "0.0"
    t.decimal "minimum_balance", default: "0.0"
    t.uuid "cooperative_id"
    t.index ["cooperative_id"], name: "index_share_capital_products_on_cooperative_id"
    t.index ["name"], name: "index_share_capital_products_on_name"
    t.index ["paid_up_account_id"], name: "index_share_capital_products_on_paid_up_account_id"
    t.index ["subscription_account_id"], name: "index_share_capital_products_on_subscription_account_id"
  end

  create_table "share_capitals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "share_capital_product_id"
    t.string "account_number"
    t.datetime "date_opened"
    t.string "account_owner_name"
    t.datetime "created_at", default: "2018-10-29 07:23:23", null: false
    t.datetime "updated_at", default: "2018-10-29 07:23:23", null: false
    t.integer "status"
    t.uuid "office_id"
    t.string "subscriber_type"
    t.uuid "subscriber_id"
    t.boolean "has_minimum_balance", default: false
    t.datetime "last_transaction_date"
    t.uuid "cart_id"
    t.uuid "barangay_id"
    t.uuid "organization_id"
    t.uuid "cooperative_id"
    t.index ["account_number"], name: "index_share_capitals_on_account_number", unique: true
    t.index ["barangay_id"], name: "index_share_capitals_on_barangay_id"
    t.index ["cart_id"], name: "index_share_capitals_on_cart_id"
    t.index ["cooperative_id"], name: "index_share_capitals_on_cooperative_id"
    t.index ["office_id"], name: "index_share_capitals_on_office_id"
    t.index ["organization_id"], name: "index_share_capitals_on_organization_id"
    t.index ["share_capital_product_id"], name: "index_share_capitals_on_share_capital_product_id"
    t.index ["status"], name: "index_share_capitals_on_status"
    t.index ["subscriber_type", "subscriber_id"], name: "index_share_capitals_on_subscriber_type_and_subscriber_id"
  end

  create_table "store_fronts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "accounts_receivable_account_id"
    t.uuid "cost_of_goods_sold_account_id"
    t.uuid "accounts_payable_account_id"
    t.uuid "merchandise_inventory_account_id"
    t.uuid "sales_account_id"
    t.uuid "sales_return_account_id"
    t.uuid "spoilage_account_id"
    t.uuid "sales_discount_account_id"
    t.uuid "purchase_return_account_id"
    t.uuid "internal_use_account_id"
    t.string "business_type"
    t.uuid "business_id"
    t.index ["accounts_payable_account_id"], name: "index_store_fronts_on_accounts_payable_account_id"
    t.index ["accounts_receivable_account_id"], name: "index_store_fronts_on_accounts_receivable_account_id"
    t.index ["business_type", "business_id"], name: "index_store_fronts_on_business_type_and_business_id"
    t.index ["cost_of_goods_sold_account_id"], name: "index_store_fronts_on_cost_of_goods_sold_account_id"
    t.index ["internal_use_account_id"], name: "index_store_fronts_on_internal_use_account_id"
    t.index ["merchandise_inventory_account_id"], name: "index_store_fronts_on_merchandise_inventory_account_id"
    t.index ["purchase_return_account_id"], name: "index_store_fronts_on_purchase_return_account_id"
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
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "termable_type"
    t.uuid "termable_id"
    t.datetime "effectivity_date"
    t.datetime "maturity_date"
    t.integer "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["account_number"], name: "index_time_deposit_applications_on_account_number", unique: true
    t.index ["depositor_type", "depositor_id"], name: "index_depositor_on_time_deposit_applications"
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
    t.index ["account_number"], name: "index_time_deposits_on_account_number", unique: true
    t.index ["cooperative_id"], name: "index_time_deposits_on_cooperative_id"
    t.index ["depositor_type", "depositor_id"], name: "index_time_deposits_on_depositor_type_and_depositor_id"
    t.index ["membership_id"], name: "index_time_deposits_on_membership_id"
    t.index ["office_id"], name: "index_time_deposits_on_office_id"
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

  create_table "unit_of_measurements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.string "code"
    t.string "description"
    t.decimal "quantity"
    t.decimal "conversion_quantity"
    t.boolean "base_measurement", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.decimal "amount"
    t.uuid "account_id"
    t.uuid "voucher_id"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "amount_type", default: 0
    t.uuid "amount_adjustment_id"
    t.uuid "recorder_id"
    t.index ["account_id"], name: "index_voucher_amounts_on_account_id"
    t.index ["amount_adjustment_id"], name: "index_voucher_amounts_on_amount_adjustment_id"
    t.index ["amount_type"], name: "index_voucher_amounts_on_amount_type"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_voucher_amount"
    t.index ["recorder_id"], name: "index_voucher_amounts_on_recorder_id"
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
    t.index ["account_number"], name: "index_vouchers_on_account_number", unique: true
    t.index ["cooperative_id"], name: "index_vouchers_on_cooperative_id"
    t.index ["cooperative_service_id"], name: "index_vouchers_on_cooperative_service_id"
    t.index ["disburser_id"], name: "index_vouchers_on_disburser_id"
    t.index ["entry_id"], name: "index_vouchers_on_entry_id"
    t.index ["office_id"], name: "index_vouchers_on_office_id"
    t.index ["payee_type", "payee_id"], name: "index_vouchers_on_payee_type_and_payee_id"
    t.index ["preparer_id"], name: "index_vouchers_on_preparer_id"
    t.index ["token"], name: "index_vouchers_on_token"
  end

  add_foreign_key "account_budgets", "accounts"
  add_foreign_key "account_budgets", "cooperatives"
  add_foreign_key "accountable_accounts", "accounts"
  add_foreign_key "accounts", "accounts", column: "main_account_id"
  add_foreign_key "addresses", "barangays"
  add_foreign_key "addresses", "municipalities"
  add_foreign_key "addresses", "provinces"
  add_foreign_key "addresses", "streets"
  add_foreign_key "amortization_schedules", "accounts", column: "credit_account_id"
  add_foreign_key "amortization_schedules", "accounts", column: "debit_account_id"
  add_foreign_key "amortization_schedules", "loan_applications"
  add_foreign_key "amortization_schedules", "loans"
  add_foreign_key "amount_adjustments", "loan_applications"
  add_foreign_key "amount_adjustments", "voucher_amounts"
  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "bank_accounts", "accounts"
  add_foreign_key "bank_accounts", "accounts", column: "earned_interest_account_id"
  add_foreign_key "bank_accounts", "cooperatives"
  add_foreign_key "barangays", "cooperatives"
  add_foreign_key "barangays", "municipalities"
  add_foreign_key "beneficiaries", "members"
  add_foreign_key "carts", "users"
  add_foreign_key "charge_adjustments", "loan_charges"
  add_foreign_key "charges", "accounts"
  add_foreign_key "cooperative_services", "cooperatives"
  add_foreign_key "cooperatives", "interest_amortization_configs"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "credit_account_id"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "debit_account_id"
  add_foreign_key "employee_cash_accounts", "accounts", column: "cash_account_id"
  add_foreign_key "employee_cash_accounts", "users", column: "employee_id"
  add_foreign_key "entries", "cooperative_services"
  add_foreign_key "entries", "cooperatives"
  add_foreign_key "entries", "entries", column: "previous_entry_id"
  add_foreign_key "entries", "offices"
  add_foreign_key "entries", "official_receipts"
  add_foreign_key "entries", "users", column: "cancelled_by_id"
  add_foreign_key "entries", "users", column: "recorder_id"
  add_foreign_key "interest_configs", "accounts", column: "interest_revenue_account_id"
  add_foreign_key "interest_configs", "accounts", column: "unearned_interest_income_account_id"
  add_foreign_key "interest_configs", "cooperatives"
  add_foreign_key "interest_configs", "loan_products"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "line_items", column: "referenced_line_item_id"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "line_items", "unit_of_measurements"
  add_foreign_key "loan_applications", "cooperatives"
  add_foreign_key "loan_applications", "loan_products"
  add_foreign_key "loan_applications", "offices"
  add_foreign_key "loan_applications", "organizations"
  add_foreign_key "loan_applications", "users", column: "preparer_id"
  add_foreign_key "loan_charge_payment_schedules", "amortization_schedules"
  add_foreign_key "loan_charge_payment_schedules", "loan_charges"
  add_foreign_key "loan_charge_payment_schedules", "loans"
  add_foreign_key "loan_charges", "charges"
  add_foreign_key "loan_charges", "loans"
  add_foreign_key "loan_discounts", "loans"
  add_foreign_key "loan_discounts", "users", column: "computed_by_id"
  add_foreign_key "loan_interests", "loans"
  add_foreign_key "loan_interests", "users", column: "computed_by_id"
  add_foreign_key "loan_penalties", "loans"
  add_foreign_key "loan_penalties", "users", column: "computed_by_id"
  add_foreign_key "loan_product_charges", "charges"
  add_foreign_key "loan_product_charges", "loan_products"
  add_foreign_key "loan_products", "accounts", column: "loans_receivable_current_account_id"
  add_foreign_key "loan_products", "accounts", column: "loans_receivable_past_due_account_id"
  add_foreign_key "loan_products", "cooperatives"
  add_foreign_key "loan_protection_funds", "cooperatives"
  add_foreign_key "loan_protection_plan_providers", "accounts"
  add_foreign_key "loans", "barangays"
  add_foreign_key "loans", "cooperatives"
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
  add_foreign_key "members", "offices"
  add_foreign_key "membership_beneficiaries", "memberships"
  add_foreign_key "memberships", "cooperatives"
  add_foreign_key "municipalities", "cooperatives"
  add_foreign_key "municipalities", "provinces"
  add_foreign_key "notes", "users", column: "noter_id"
  add_foreign_key "offices", "accounts", column: "cash_in_vault_account_id"
  add_foreign_key "offices", "cooperatives"
  add_foreign_key "orders", "store_fronts"
  add_foreign_key "orders", "users", column: "employee_id"
  add_foreign_key "organization_members", "organizations"
  add_foreign_key "organizations", "cooperatives"
  add_foreign_key "penalty_configs", "accounts", column: "penalty_revenue_account_id"
  add_foreign_key "penalty_configs", "cooperatives"
  add_foreign_key "penalty_configs", "loan_products"
  add_foreign_key "products", "categories"
  add_foreign_key "program_subscriptions", "programs"
  add_foreign_key "programs", "accounts"
  add_foreign_key "programs", "cooperatives"
  add_foreign_key "registries", "suppliers"
  add_foreign_key "registries", "users", column: "employee_id"
  add_foreign_key "saving_products", "accounts"
  add_foreign_key "saving_products", "accounts", column: "closing_account_id"
  add_foreign_key "saving_products", "accounts", column: "interest_expense_account_id"
  add_foreign_key "saving_products", "cooperatives"
  add_foreign_key "savings", "barangays"
  add_foreign_key "savings", "carts"
  add_foreign_key "savings", "cooperatives"
  add_foreign_key "savings", "offices"
  add_foreign_key "savings", "saving_products"
  add_foreign_key "savings_account_applications", "saving_products"
  add_foreign_key "savings_account_configs", "accounts", column: "closing_account_id"
  add_foreign_key "savings_account_configs", "accounts", column: "interest_expense_account_id"
  add_foreign_key "share_capital_applications", "cooperatives"
  add_foreign_key "share_capital_applications", "offices"
  add_foreign_key "share_capital_applications", "share_capital_products"
  add_foreign_key "share_capital_products", "accounts", column: "paid_up_account_id"
  add_foreign_key "share_capital_products", "accounts", column: "subscription_account_id"
  add_foreign_key "share_capital_products", "cooperatives"
  add_foreign_key "share_capitals", "barangays"
  add_foreign_key "share_capitals", "carts"
  add_foreign_key "share_capitals", "cooperatives"
  add_foreign_key "share_capitals", "offices"
  add_foreign_key "share_capitals", "organizations"
  add_foreign_key "share_capitals", "share_capital_products"
  add_foreign_key "store_fronts", "accounts", column: "accounts_payable_account_id"
  add_foreign_key "store_fronts", "accounts", column: "accounts_receivable_account_id"
  add_foreign_key "store_fronts", "accounts", column: "cost_of_goods_sold_account_id"
  add_foreign_key "store_fronts", "accounts", column: "internal_use_account_id"
  add_foreign_key "store_fronts", "accounts", column: "merchandise_inventory_account_id"
  add_foreign_key "store_fronts", "accounts", column: "purchase_return_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_discount_account_id"
  add_foreign_key "store_fronts", "accounts", column: "sales_return_account_id"
  add_foreign_key "store_fronts", "accounts", column: "spoilage_account_id"
  add_foreign_key "streets", "barangays"
  add_foreign_key "streets", "municipalities"
  add_foreign_key "time_deposit_applications", "time_deposit_products"
  add_foreign_key "time_deposit_applications", "vouchers"
  add_foreign_key "time_deposit_configs", "accounts"
  add_foreign_key "time_deposit_configs", "accounts", column: "break_contract_account_id"
  add_foreign_key "time_deposit_configs", "accounts", column: "interest_account_id"
  add_foreign_key "time_deposit_products", "accounts"
  add_foreign_key "time_deposit_products", "accounts", column: "break_contract_account_id"
  add_foreign_key "time_deposit_products", "accounts", column: "interest_expense_account_id"
  add_foreign_key "time_deposit_products", "cooperatives"
  add_foreign_key "time_deposits", "cooperatives"
  add_foreign_key "time_deposits", "memberships"
  add_foreign_key "time_deposits", "offices"
  add_foreign_key "time_deposits", "time_deposit_products"
  add_foreign_key "unit_of_measurements", "products"
  add_foreign_key "users", "cooperatives"
  add_foreign_key "users", "offices"
  add_foreign_key "users", "store_fronts"
  add_foreign_key "voucher_amounts", "accounts"
  add_foreign_key "voucher_amounts", "amount_adjustments"
  add_foreign_key "voucher_amounts", "users", column: "recorder_id"
  add_foreign_key "voucher_amounts", "vouchers"
  add_foreign_key "vouchers", "cooperative_services"
  add_foreign_key "vouchers", "cooperatives"
  add_foreign_key "vouchers", "entries"
  add_foreign_key "vouchers", "offices"
  add_foreign_key "vouchers", "users", column: "disburser_id"
  add_foreign_key "vouchers", "users", column: "preparer_id"
end
