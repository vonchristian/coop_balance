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

ActiveRecord::Schema.define(version: 2017_12_09_072645) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "account_receivable_store_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_receivable_store_configs_on_account_id"
  end

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "contra", default: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "main_account_id"
    t.index ["code"], name: "index_accounts_on_code", unique: true
    t.index ["main_account_id"], name: "index_accounts_on_main_account_id"
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["type"], name: "index_accounts_on_type"
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
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "amortization_schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.datetime "date"
    t.decimal "principal"
    t.decimal "interest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.index ["loan_id"], name: "index_amortization_schedules_on_loan_id"
  end

  create_table "amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "entry_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.uuid "recorder_id"
    t.index ["account_id", "entry_id"], name: "index_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_amounts_on_account_id"
    t.index ["entry_id", "account_id"], name: "index_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_amounts_on_entry_id"
    t.index ["recorder_id"], name: "index_amounts_on_recorder_id"
    t.index ["type"], name: "index_amounts_on_type"
  end

  create_table "appraisals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "real_property_id"
    t.decimal "market_value"
    t.datetime "date_appraised"
    t.uuid "appraiser_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appraiser_id"], name: "index_appraisals_on_appraiser_id"
    t.index ["real_property_id"], name: "index_appraisals_on_real_property_id"
  end

  create_table "bank_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "bank_name"
    t.string "bank_address"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_bank_accounts_on_cooperative_id"
  end

  create_table "barangays", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "municipality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["municipality_id"], name: "index_barangays_on_municipality_id"
    t.index ["name"], name: "index_barangays_on_name"
  end

  create_table "branch_offices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "address"
    t.string "branch_name"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "branch_type"
    t.index ["branch_type"], name: "index_branch_offices_on_branch_type"
    t.index ["cooperative_id"], name: "index_branch_offices_on_cooperative_id"
  end

  create_table "break_contract_fees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.decimal "amount"
    t.decimal "rate"
    t.integer "fee_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_break_contract_fees_on_account_id"
  end

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "amortize_balance", default: false
    t.index ["loan_charge_id"], name: "index_charge_adjustments_on_loan_charge_id"
  end

  create_table "charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "charge_type"
    t.decimal "amount"
    t.decimal "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.integer "category"
    t.uuid "account_id"
    t.decimal "minimum_loan_amount"
    t.decimal "maximum_loan_amount"
    t.boolean "depends_on_loan_amount", default: false
    t.index ["account_id"], name: "index_charges_on_account_id"
    t.index ["category"], name: "index_charges_on_category"
    t.index ["charge_type"], name: "index_charges_on_charge_type"
  end

  create_table "collaterals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.uuid "real_property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_collaterals_on_loan_id"
    t.index ["real_property_id"], name: "index_collaterals_on_real_property_id"
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
    t.uuid "committee_id"
    t.index ["committee_id"], name: "index_committee_members_on_committee_id"
    t.index ["confirmation_token"], name: "index_committee_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_committee_members_on_email", unique: true
    t.index ["reset_password_token"], name: "index_committee_members_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_committee_members_on_unlock_token", unique: true
  end

  create_table "committees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_committees_on_name", unique: true
  end

  create_table "contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cooperatives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.string "address"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "abbreviated_name"
    t.index ["abbreviated_name"], name: "index_cooperatives_on_abbreviated_name", unique: true
  end

  create_table "days_workeds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "number_of_days"
    t.uuid "laborer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["laborer_id"], name: "index_days_workeds_on_laborer_id"
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

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "title"
    t.datetime "date"
    t.string "uploader_type"
    t.uuid "uploader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uploader_type", "uploader_id"], name: "index_documents_on_uploader_type_and_uploader_id"
  end

  create_table "employee_contributions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "employee_id"
    t.uuid "contribution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contribution_id"], name: "index_employee_contributions_on_contribution_id"
    t.index ["employee_id"], name: "index_employee_contributions_on_employee_id"
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "reference_number"
    t.datetime "entry_date"
    t.string "commercial_document_type"
    t.uuid "commercial_document_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entry_type"
    t.uuid "recorder_id"
    t.uuid "department_id"
    t.uuid "voucher_id"
    t.uuid "branch_office_id"
    t.uuid "section_id"
    t.uuid "store_front_id"
    t.integer "payment_type", default: 0
    t.index ["branch_office_id"], name: "index_entries_on_branch_office_id"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
    t.index ["department_id"], name: "index_entries_on_department_id"
    t.index ["entry_date"], name: "index_entries_on_entry_date"
    t.index ["entry_type"], name: "index_entries_on_entry_type"
    t.index ["payment_type"], name: "index_entries_on_payment_type"
    t.index ["recorder_id"], name: "index_entries_on_recorder_id"
    t.index ["section_id"], name: "index_entries_on_section_id"
    t.index ["store_front_id"], name: "index_entries_on_store_front_id"
    t.index ["voucher_id"], name: "index_entries_on_voucher_id"
  end

  create_table "finished_good_materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "raw_material_id"
    t.decimal "quantity"
    t.string "unit"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "product_id"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.index ["product_id"], name: "index_finished_good_materials_on_product_id"
    t.index ["raw_material_id"], name: "index_finished_good_materials_on_raw_material_id"
  end

  create_table "fixed_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "time_deposit_id"
    t.datetime "deposit_date"
    t.datetime "maturity_date"
    t.integer "number_of_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_deposit_id"], name: "index_fixed_terms_on_time_deposit_id"
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

  create_table "interest_rebate_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "invoicable_type"
    t.bigint "invoicable_id"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoicable_type", "invoicable_id"], name: "index_invoices_on_invoicable_type_and_invoicable_id"
    t.index ["number"], name: "index_invoices_on_number", unique: true
    t.index ["type"], name: "index_invoices_on_type"
  end

  create_table "laborers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.decimal "daily_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "order_id"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity"
    t.uuid "cart_id"
    t.string "line_itemable_type"
    t.uuid "line_itemable_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["line_itemable_type", "line_itemable_id"], name: "index_line_items_on_line_itemable_type_and_line_itemable_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "loan_approvals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status"
    t.datetime "date_approved"
    t.uuid "approver_id"
    t.uuid "loan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["approver_id"], name: "index_loan_approvals_on_approver_id"
    t.index ["loan_id"], name: "index_loan_approvals_on_loan_id"
    t.index ["status"], name: "index_loan_approvals_on_status"
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
    t.string "chargeable_type"
    t.uuid "chargeable_id"
    t.index ["chargeable_type", "chargeable_id"], name: "index_loan_charges_on_chargeable_type_and_chargeable_id"
    t.index ["loan_id"], name: "index_loan_charges_on_loan_id"
  end

  create_table "loan_co_makers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "co_maker_type"
    t.uuid "co_maker_id"
    t.index ["co_maker_type", "co_maker_id"], name: "index_loan_co_makers_on_co_maker_type_and_co_maker_id"
    t.index ["loan_id"], name: "index_loan_co_makers_on_loan_id"
  end

  create_table "loan_interest_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_loan_interest_configs_on_account_id"
  end

  create_table "loan_penalty_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "number_of_days"
    t.decimal "interest_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.index ["account_id"], name: "index_loan_penalty_configs_on_account_id"
  end

  create_table "loan_product_charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "charge_id"
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_loan_product_charges_on_charge_id"
    t.index ["loan_product_id"], name: "index_loan_product_charges_on_loan_product_id"
  end

  create_table "loan_product_interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "rate"
    t.uuid "loan_product_id"
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_loan_product_interests_on_account_id"
    t.index ["loan_product_id"], name: "index_loan_product_interests_on_loan_product_id"
  end

  create_table "loan_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "max_loanable_amount"
    t.decimal "loan_product_term"
    t.integer "mode_of_payment"
    t.uuid "account_id"
    t.string "name"
    t.decimal "minimum_loanable_amount"
    t.string "depends_on_share_capital_balance"
    t.decimal "minimum_share_capital_balance"
    t.decimal "maximum_share_capital_balance"
    t.string "slug"
    t.index ["account_id"], name: "index_loan_products_on_account_id"
    t.index ["name"], name: "index_loan_products_on_name", unique: true
    t.index ["slug"], name: "index_loan_products_on_slug", unique: true
  end

  create_table "loan_protection_fund_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_loan_protection_fund_configs_on_account_id"
  end

  create_table "loan_protection_funds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.decimal "rate"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.uuid "loan_protection_rate_id"
    t.index ["account_id"], name: "index_loan_protection_funds_on_account_id"
    t.index ["loan_id"], name: "index_loan_protection_funds_on_loan_id"
    t.index ["loan_protection_rate_id"], name: "index_loan_protection_funds_on_loan_protection_rate_id"
  end

  create_table "loan_protection_providers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "business_name"
    t.string "adddress"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loan_protection_rates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "term"
    t.decimal "min_age"
    t.decimal "max_age"
    t.decimal "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.datetime "application_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "loan_amount"
    t.decimal "duration"
    t.integer "loan_term_duration"
    t.integer "loan_status", default: 0
    t.decimal "term"
    t.integer "mode_of_payment"
    t.uuid "barangay_id"
    t.uuid "street_id"
    t.uuid "municipality_id"
    t.uuid "organization_id"
    t.uuid "employee_id"
    t.string "borrower_type"
    t.uuid "borrower_id"
    t.string "borrower_full_name"
    t.uuid "preparer_id"
    t.index ["barangay_id"], name: "index_loans_on_barangay_id"
    t.index ["borrower_type", "borrower_id"], name: "index_loans_on_borrower_type_and_borrower_id"
    t.index ["employee_id"], name: "index_loans_on_employee_id"
    t.index ["loan_product_id"], name: "index_loans_on_loan_product_id"
    t.index ["mode_of_payment"], name: "index_loans_on_mode_of_payment"
    t.index ["municipality_id"], name: "index_loans_on_municipality_id"
    t.index ["organization_id"], name: "index_loans_on_organization_id"
    t.index ["preparer_id"], name: "index_loans_on_preparer_id"
    t.index ["street_id"], name: "index_loans_on_street_id"
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
    t.date "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "contact_number"
    t.integer "civil_status"
    t.string "fullname"
    t.string "slug"
    t.integer "birth_month"
    t.integer "birth_day"
    t.string "email", default: "", null: false
    t.uuid "branch_office_id"
    t.index ["branch_office_id"], name: "index_members_on_branch_office_id"
    t.index ["fullname"], name: "index_members_on_fullname", unique: true
    t.index ["sex"], name: "index_members_on_sex"
    t.index ["slug"], name: "index_members_on_slug", unique: true
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "memberable_type"
    t.uuid "memberable_id"
    t.datetime "membership_date"
    t.uuid "cooperative_id"
    t.integer "membership_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_number"
    t.datetime "application_date"
    t.datetime "approval_date"
    t.index ["account_number"], name: "index_memberships_on_account_number", unique: true
    t.index ["cooperative_id"], name: "index_memberships_on_cooperative_id"
    t.index ["memberable_type", "memberable_id"], name: "index_memberships_on_memberable_type_and_memberable_id"
    t.index ["membership_type"], name: "index_memberships_on_membership_type"
  end

  create_table "menus", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_menus_on_name", unique: true
  end

  create_table "mode_of_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mode"], name: "index_mode_of_payments_on_mode"
  end

  create_table "municipalities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_municipalities_on_name"
  end

  create_table "notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "noteable_type"
    t.uuid "noteable_id"
    t.uuid "noter_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_type"
    t.uuid "user_id"
    t.decimal "cash_tendered"
    t.decimal "total_cost"
    t.decimal "order_change"
    t.uuid "employee_id"
    t.string "customer_type"
    t.uuid "customer_id"
    t.index ["customer_type", "customer_id"], name: "index_orders_on_customer_type_and_customer_id"
    t.index ["employee_id"], name: "index_orders_on_employee_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
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
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.uuid "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "pictures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "pictureable_type"
    t.uuid "pictureable_id"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pictureable_type", "pictureable_id"], name: "index_pictures_on_pictureable_type_and_pictureable_id"
  end

  create_table "product_stocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.uuid "product_id"
    t.uuid "supplier_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantity"
    t.string "barcode"
    t.uuid "registry_id"
    t.string "name"
    t.decimal "retail_price"
    t.decimal "wholesale_price"
    t.index ["product_id"], name: "index_product_stocks_on_product_id"
    t.index ["registry_id"], name: "index_product_stocks_on_registry_id"
    t.index ["supplier_id"], name: "index_product_stocks_on_supplier_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "name"
    t.uuid "category_id"
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
    t.decimal "contribution"
    t.boolean "default_program", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.uuid "account_id"
    t.integer "payment_schedule_type"
    t.index ["account_id"], name: "index_programs_on_account_id"
    t.index ["payment_schedule_type"], name: "index_programs_on_payment_schedule_type"
  end

  create_table "raw_material_stocks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "supplier_id"
    t.uuid "raw_material_id"
    t.decimal "quantity"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.datetime "delivery_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_freight", default: false
    t.boolean "discounted", default: false
    t.decimal "freight_in", default: "0.0"
    t.decimal "discount_amount", default: "0.0"
    t.index ["raw_material_id"], name: "index_raw_material_stocks_on_raw_material_id"
    t.index ["supplier_id"], name: "index_raw_material_stocks_on_supplier_id"
  end

  create_table "raw_materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_raw_materials_on_name", unique: true
  end

  create_table "real_properties", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.string "address"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.uuid "owner_id"
    t.text "description"
    t.index ["member_id"], name: "index_real_properties_on_member_id"
    t.index ["owner_type", "owner_id"], name: "index_real_properties_on_owner_type_and_owner_id"
    t.index ["type"], name: "index_real_properties_on_type"
  end

  create_table "registries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "date"
    t.string "spreadsheet_file_name"
    t.string "spreadsheet_content_type"
    t.integer "spreadsheet_file_size"
    t.datetime "spreadsheet_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.uuid "supplier_id"
    t.string "number"
    t.uuid "employee_id"
    t.index ["employee_id"], name: "index_registries_on_employee_id"
    t.index ["supplier_id"], name: "index_registries_on_supplier_id"
    t.index ["type"], name: "index_registries_on_type"
  end

  create_table "salary_grades", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saving_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "interest_rate"
    t.integer "interest_recurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "account_id"
    t.decimal "minimum_balance"
    t.index ["account_id"], name: "index_saving_products_on_account_id"
    t.index ["name"], name: "index_saving_products_on_name", unique: true
  end

  create_table "savings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "saving_product_id"
    t.string "account_owner_name"
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.integer "status"
    t.uuid "branch_office_id"
    t.uuid "section_id"
    t.index ["account_number"], name: "index_savings_on_account_number", unique: true
    t.index ["branch_office_id"], name: "index_savings_on_branch_office_id"
    t.index ["depositor_type", "depositor_id"], name: "index_savings_on_depositor_type_and_depositor_id"
    t.index ["saving_product_id"], name: "index_savings_on_saving_product_id"
    t.index ["section_id"], name: "index_savings_on_section_id"
  end

  create_table "savings_account_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "closing_account_fee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "interest_account_id"
    t.index ["interest_account_id"], name: "index_savings_account_configs_on_interest_account_id"
  end

  create_table "sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "branch_office_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_office_id"], name: "index_sections_on_branch_office_id"
    t.index ["name"], name: "index_sections_on_name", unique: true
  end

  create_table "share_capital_product_shares", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "share_capital_product_id"
    t.decimal "share_count"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost_per_share"
    t.index ["share_capital_product_id"], name: "index_share_capital_product_shares_on_share_capital_product_id"
  end

  create_table "share_capital_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost_per_share"
    t.decimal "minimum_number_of_subscribed_share"
    t.decimal "minimum_number_of_paid_share"
    t.boolean "default_product", default: false
    t.uuid "paid_up_account_id"
    t.uuid "subscription_account_id"
    t.index ["name"], name: "index_share_capital_products_on_name"
    t.index ["paid_up_account_id"], name: "index_share_capital_products_on_paid_up_account_id"
    t.index ["subscription_account_id"], name: "index_share_capital_products_on_subscription_account_id"
  end

  create_table "share_capitals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "account_number"
    t.datetime "date_opened"
    t.string "type"
    t.uuid "share_capital_product_id"
    t.string "account_owner_name"
    t.string "subscriber_type"
    t.uuid "subscriber_id"
    t.datetime "created_at", default: "2017-11-27 11:44:53", null: false
    t.datetime "updated_at", default: "2017-11-27 11:44:53", null: false
    t.integer "status"
    t.uuid "branch_office_id"
    t.uuid "section_id"
    t.index ["account_number"], name: "index_share_capitals_on_account_number", unique: true
    t.index ["branch_office_id"], name: "index_share_capitals_on_branch_office_id"
    t.index ["section_id"], name: "index_share_capitals_on_section_id"
    t.index ["share_capital_product_id"], name: "index_share_capitals_on_share_capital_product_id"
    t.index ["status"], name: "index_share_capitals_on_status"
    t.index ["subscriber_type", "subscriber_id"], name: "index_share_capitals_on_subscriber_type_and_subscriber_id"
    t.index ["type"], name: "index_share_capitals_on_type"
  end

  create_table "store_fronts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "cooperative_id"
    t.string "name"
    t.string "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cooperative_id"], name: "index_store_fronts_on_cooperative_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "business_name"
    t.string "address"
  end

  create_table "time_deposit_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "minimum_amount"
    t.decimal "maximum_amount"
    t.decimal "interest_rate"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_days"
    t.integer "time_deposit_product_type"
    t.uuid "account_id"
    t.index ["account_id"], name: "index_time_deposit_products_on_account_id"
    t.index ["name"], name: "index_time_deposit_products_on_name", unique: true
  end

  create_table "time_deposits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "time_deposit_product_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "depositor_name"
    t.string "depositor_type"
    t.uuid "depositor_id"
    t.integer "status"
    t.index ["account_number"], name: "index_time_deposits_on_account_number", unique: true
    t.index ["depositor_type", "depositor_id"], name: "index_time_deposits_on_depositor_type_and_depositor_id"
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
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.uuid "department_id"
    t.string "contact_number"
    t.date "date_of_birth"
    t.integer "sex"
    t.uuid "salary_grade_id"
    t.uuid "cooperative_id"
    t.date "date_or_birth"
    t.integer "birth_month"
    t.integer "birth_day"
    t.uuid "cash_on_hand_account_id"
    t.uuid "branch_office_id"
    t.index ["branch_office_id"], name: "index_users_on_branch_office_id"
    t.index ["cash_on_hand_account_id"], name: "index_users_on_cash_on_hand_account_id"
    t.index ["cooperative_id"], name: "index_users_on_cooperative_id"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["salary_grade_id"], name: "index_users_on_salary_grade_id"
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
    t.integer "amount_type"
    t.index ["account_id"], name: "index_voucher_amounts_on_account_id"
    t.index ["amount_type"], name: "index_voucher_amounts_on_amount_type"
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_voucher_amount"
    t.index ["voucher_id"], name: "index_voucher_amounts_on_voucher_id"
  end

  create_table "vouchers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "voucherable_type"
    t.uuid "voucherable_id"
    t.string "payee_type"
    t.uuid "payee_id"
    t.uuid "user_id"
    t.string "description"
    t.integer "status"
    t.decimal "payable_amount"
    t.string "type"
    t.uuid "preparer_id"
    t.uuid "disburser_id"
    t.index ["disburser_id"], name: "index_vouchers_on_disburser_id"
    t.index ["payee_type", "payee_id"], name: "index_vouchers_on_payee_type_and_payee_id"
    t.index ["preparer_id"], name: "index_vouchers_on_preparer_id"
    t.index ["status"], name: "index_vouchers_on_status"
    t.index ["type"], name: "index_vouchers_on_type"
    t.index ["user_id"], name: "index_vouchers_on_user_id"
    t.index ["voucherable_type", "voucherable_id"], name: "index_vouchers_on_voucherable_type_and_voucherable_id"
  end

  create_table "work_in_process_materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "raw_material_id"
    t.decimal "quantity"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["raw_material_id"], name: "index_work_in_process_materials_on_raw_material_id"
  end

  create_table "work_in_progress_materials", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "raw_material_id"
    t.datetime "date"
    t.decimal "quantity"
    t.decimal "unit_cost"
    t.decimal "total_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["raw_material_id"], name: "index_work_in_progress_materials_on_raw_material_id"
  end

  add_foreign_key "account_receivable_store_configs", "accounts"
  add_foreign_key "accounts", "accounts", column: "main_account_id"
  add_foreign_key "amortization_schedules", "loans"
  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "amounts", "users", column: "recorder_id"
  add_foreign_key "appraisals", "real_properties"
  add_foreign_key "appraisals", "users", column: "appraiser_id"
  add_foreign_key "bank_accounts", "cooperatives"
  add_foreign_key "barangays", "municipalities"
  add_foreign_key "branch_offices", "cooperatives"
  add_foreign_key "break_contract_fees", "accounts"
  add_foreign_key "carts", "users"
  add_foreign_key "charge_adjustments", "loan_charges"
  add_foreign_key "charges", "accounts"
  add_foreign_key "collaterals", "loans"
  add_foreign_key "collaterals", "real_properties"
  add_foreign_key "committee_members", "committees"
  add_foreign_key "days_workeds", "laborers"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "credit_account_id"
  add_foreign_key "documentary_stamp_taxes", "accounts", column: "debit_account_id"
  add_foreign_key "employee_contributions", "contributions"
  add_foreign_key "employee_contributions", "users", column: "employee_id"
  add_foreign_key "entries", "branch_offices"
  add_foreign_key "entries", "departments"
  add_foreign_key "entries", "sections"
  add_foreign_key "entries", "store_fronts"
  add_foreign_key "entries", "users", column: "recorder_id"
  add_foreign_key "entries", "vouchers"
  add_foreign_key "finished_good_materials", "products"
  add_foreign_key "finished_good_materials", "raw_materials"
  add_foreign_key "fixed_terms", "time_deposits"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "loan_approvals", "loans"
  add_foreign_key "loan_approvals", "users", column: "approver_id"
  add_foreign_key "loan_charge_payment_schedules", "amortization_schedules"
  add_foreign_key "loan_charge_payment_schedules", "loan_charges"
  add_foreign_key "loan_charge_payment_schedules", "loans"
  add_foreign_key "loan_charges", "loans"
  add_foreign_key "loan_co_makers", "loans"
  add_foreign_key "loan_interest_configs", "accounts"
  add_foreign_key "loan_penalty_configs", "accounts"
  add_foreign_key "loan_product_charges", "charges"
  add_foreign_key "loan_product_charges", "loan_products"
  add_foreign_key "loan_product_interests", "accounts"
  add_foreign_key "loan_product_interests", "loan_products"
  add_foreign_key "loan_products", "accounts"
  add_foreign_key "loan_protection_fund_configs", "accounts"
  add_foreign_key "loan_protection_funds", "accounts"
  add_foreign_key "loan_protection_funds", "loan_protection_rates"
  add_foreign_key "loan_protection_funds", "loans"
  add_foreign_key "loans", "barangays"
  add_foreign_key "loans", "loan_products"
  add_foreign_key "loans", "municipalities"
  add_foreign_key "loans", "organizations"
  add_foreign_key "loans", "streets"
  add_foreign_key "loans", "users", column: "employee_id"
  add_foreign_key "loans", "users", column: "preparer_id"
  add_foreign_key "member_occupations", "members"
  add_foreign_key "member_occupations", "occupations"
  add_foreign_key "members", "branch_offices"
  add_foreign_key "memberships", "cooperatives"
  add_foreign_key "notes", "users", column: "noter_id"
  add_foreign_key "orders", "users"
  add_foreign_key "orders", "users", column: "employee_id"
  add_foreign_key "organization_members", "organizations"
  add_foreign_key "product_stocks", "products"
  add_foreign_key "product_stocks", "registries"
  add_foreign_key "product_stocks", "suppliers"
  add_foreign_key "products", "categories"
  add_foreign_key "program_subscriptions", "programs"
  add_foreign_key "programs", "accounts"
  add_foreign_key "raw_material_stocks", "raw_materials"
  add_foreign_key "raw_material_stocks", "suppliers"
  add_foreign_key "real_properties", "members"
  add_foreign_key "registries", "suppliers"
  add_foreign_key "registries", "users", column: "employee_id"
  add_foreign_key "saving_products", "accounts"
  add_foreign_key "savings", "branch_offices"
  add_foreign_key "savings", "saving_products"
  add_foreign_key "savings", "sections"
  add_foreign_key "savings_account_configs", "accounts", column: "interest_account_id"
  add_foreign_key "sections", "branch_offices"
  add_foreign_key "share_capital_product_shares", "share_capital_products"
  add_foreign_key "share_capital_products", "accounts", column: "paid_up_account_id"
  add_foreign_key "share_capital_products", "accounts", column: "subscription_account_id"
  add_foreign_key "share_capitals", "branch_offices"
  add_foreign_key "share_capitals", "sections"
  add_foreign_key "share_capitals", "share_capital_products"
  add_foreign_key "store_fronts", "cooperatives"
  add_foreign_key "streets", "barangays"
  add_foreign_key "streets", "municipalities"
  add_foreign_key "time_deposit_products", "accounts"
  add_foreign_key "time_deposits", "time_deposit_products"
  add_foreign_key "users", "accounts", column: "cash_on_hand_account_id"
  add_foreign_key "users", "branch_offices"
  add_foreign_key "users", "cooperatives"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "salary_grades"
  add_foreign_key "voucher_amounts", "accounts"
  add_foreign_key "voucher_amounts", "vouchers"
  add_foreign_key "vouchers", "users"
  add_foreign_key "vouchers", "users", column: "disburser_id"
  add_foreign_key "vouchers", "users", column: "preparer_id"
  add_foreign_key "work_in_process_materials", "raw_materials"
  add_foreign_key "work_in_progress_materials", "raw_materials"
end
