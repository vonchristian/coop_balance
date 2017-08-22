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

ActiveRecord::Schema.define(version: 20170821122249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

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
    t.index ["loan_id"], name: "index_amortization_schedules_on_loan_id"
  end

  create_table "amounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id"
    t.uuid "entry_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount"
    t.index ["account_id", "entry_id"], name: "index_amounts_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_amounts_on_account_id"
    t.index ["entry_id", "account_id"], name: "index_amounts_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_amounts_on_entry_id"
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

  create_table "carts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "credit_account_id"
    t.uuid "debit_account_id"
    t.integer "charge_type"
    t.decimal "amount"
    t.decimal "percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_type"], name: "index_charges_on_charge_type"
    t.index ["credit_account_id"], name: "index_charges_on_credit_account_id"
    t.index ["debit_account_id"], name: "index_charges_on_debit_account_id"
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

  create_table "days_workeds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "number_of_days"
    t.uuid "laborer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["laborer_id"], name: "index_days_workeds_on_laborer_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["commercial_document_type", "commercial_document_id"], name: "index_on_commercial_document_entry"
    t.index ["department_id"], name: "index_entries_on_department_id"
    t.index ["entry_date"], name: "index_entries_on_entry_date"
    t.index ["entry_type"], name: "index_entries_on_entry_type"
    t.index ["recorder_id"], name: "index_entries_on_recorder_id"
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

  create_table "grace_periods", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "number_of_days"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "laborers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.decimal "daily_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "product_id"
    t.uuid "product_stock_id"
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
    t.index ["product_id"], name: "index_line_items_on_product_id"
    t.index ["product_stock_id"], name: "index_line_items_on_product_stock_id"
  end

  create_table "loan_approvals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status"
    t.datetime "date_approved"
    t.uuid "approver_id"
    t.uuid "loan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_loan_approvals_on_approver_id"
    t.index ["loan_id"], name: "index_loan_approvals_on_loan_id"
    t.index ["status"], name: "index_loan_approvals_on_status"
  end

  create_table "loan_co_makers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_id"
    t.uuid "co_maker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["co_maker_id"], name: "index_loan_co_makers_on_co_maker_id"
    t.index ["loan_id"], name: "index_loan_co_makers_on_loan_id"
  end

  create_table "loan_product_charges", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "charge_id"
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_loan_product_charges_on_charge_id"
    t.index ["loan_product_id"], name: "index_loan_product_charges_on_loan_product_id"
  end

  create_table "loan_product_mode_of_payments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "loan_product_id"
    t.uuid "mode_of_payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_product_id"], name: "index_loan_product_mode_of_payments_on_loan_product_id"
    t.index ["mode_of_payment_id"], name: "index_loan_product_mode_of_payments_on_mode_of_payment_id"
  end

  create_table "loan_product_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "term"
    t.uuid "loan_product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_product_id"], name: "index_loan_product_terms_on_loan_product_id"
  end

  create_table "loan_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "interest_rate"
    t.integer "interest_recurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "max_loanable_amount"
    t.decimal "loan_product_term"
    t.integer "mode_of_payment"
    t.index ["interest_recurrence"], name: "index_loan_products_on_interest_recurrence"
  end

  create_table "loans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.uuid "loan_product_id"
    t.datetime "application_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "loan_amount"
    t.decimal "duration"
    t.integer "loan_term_duration"
    t.integer "loan_status", default: 0
    t.decimal "term"
    t.index ["loan_product_id"], name: "index_loans_on_loan_product_id"
    t.index ["member_id"], name: "index_loans_on_member_id"
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
    t.index ["sex"], name: "index_members_on_sex"
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

  create_table "official_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "receiptable_type"
    t.uuid "receiptable_id"
    t.index ["receiptable_type", "receiptable_id"], name: "index_official_receipts_on_receiptable_type_and_receiptable_id"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_type"
    t.uuid "user_id"
    t.index ["member_id"], name: "index_orders_on_member_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
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
    t.index ["product_id"], name: "index_product_stocks_on_product_id"
    t.index ["supplier_id"], name: "index_product_stocks_on_supplier_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "program_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "program_id"
    t.uuid "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_program_subscriptions_on_member_id"
    t.index ["program_id"], name: "index_program_subscriptions_on_program_id"
  end

  create_table "programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "contribution"
    t.boolean "default_program", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["member_id"], name: "index_real_properties_on_member_id"
    t.index ["type"], name: "index_real_properties_on_type"
  end

  create_table "saving_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.decimal "interest_rate"
    t.integer "interest_recurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_saving_products_on_name", unique: true
  end

  create_table "savings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "saving_product_id"
    t.index ["account_number"], name: "index_savings_on_account_number", unique: true
    t.index ["member_id"], name: "index_savings_on_member_id"
    t.index ["saving_product_id"], name: "index_savings_on_saving_product_id"
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
    t.index ["name"], name: "index_share_capital_products_on_name"
  end

  create_table "share_capitals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.string "account_number"
    t.datetime "date_opened"
    t.string "type"
    t.uuid "share_capital_product_id"
    t.index ["account_number"], name: "index_share_capitals_on_account_number", unique: true
    t.index ["member_id"], name: "index_share_capitals_on_member_id"
    t.index ["share_capital_product_id"], name: "index_share_capitals_on_share_capital_product_id"
    t.index ["type"], name: "index_share_capitals_on_type"
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
  end

  create_table "time_deposit_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "minimum_amount"
    t.decimal "maximum_amount"
    t.decimal "interest_rate"
    t.string "name"
    t.integer "interest_recurrence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_time_deposit_products_on_name", unique: true
  end

  create_table "time_deposits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "member_id"
    t.uuid "time_deposit_product_id"
    t.string "account_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_number"], name: "index_time_deposits_on_account_number", unique: true
    t.index ["member_id"], name: "index_time_deposits_on_member_id"
    t.index ["time_deposit_product_id"], name: "index_time_deposits_on_time_deposit_product_id"
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
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
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

  add_foreign_key "accounts", "accounts", column: "main_account_id"
  add_foreign_key "amortization_schedules", "loans"
  add_foreign_key "amounts", "accounts"
  add_foreign_key "amounts", "entries"
  add_foreign_key "appraisals", "real_properties"
  add_foreign_key "appraisals", "users", column: "appraiser_id"
  add_foreign_key "carts", "users"
  add_foreign_key "charges", "accounts", column: "credit_account_id"
  add_foreign_key "charges", "accounts", column: "debit_account_id"
  add_foreign_key "committee_members", "committees"
  add_foreign_key "days_workeds", "laborers"
  add_foreign_key "entries", "departments"
  add_foreign_key "entries", "users", column: "recorder_id"
  add_foreign_key "finished_good_materials", "products"
  add_foreign_key "finished_good_materials", "raw_materials"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "product_stocks"
  add_foreign_key "line_items", "products"
  add_foreign_key "loan_approvals", "loans"
  add_foreign_key "loan_approvals", "users", column: "approver_id"
  add_foreign_key "loan_co_makers", "loans"
  add_foreign_key "loan_co_makers", "members", column: "co_maker_id"
  add_foreign_key "loan_product_charges", "charges"
  add_foreign_key "loan_product_charges", "loan_products"
  add_foreign_key "loan_product_mode_of_payments", "loan_products"
  add_foreign_key "loan_product_mode_of_payments", "mode_of_payments"
  add_foreign_key "loan_product_terms", "loan_products"
  add_foreign_key "loans", "loan_products"
  add_foreign_key "loans", "members"
  add_foreign_key "orders", "members"
  add_foreign_key "orders", "users"
  add_foreign_key "product_stocks", "products"
  add_foreign_key "product_stocks", "suppliers"
  add_foreign_key "program_subscriptions", "members"
  add_foreign_key "program_subscriptions", "programs"
  add_foreign_key "raw_material_stocks", "raw_materials"
  add_foreign_key "raw_material_stocks", "suppliers"
  add_foreign_key "real_properties", "members"
  add_foreign_key "savings", "members"
  add_foreign_key "savings", "saving_products"
  add_foreign_key "share_capital_product_shares", "share_capital_products"
  add_foreign_key "share_capitals", "members"
  add_foreign_key "share_capitals", "share_capital_products"
  add_foreign_key "time_deposits", "members"
  add_foreign_key "time_deposits", "time_deposit_products"
  add_foreign_key "users", "departments"
  add_foreign_key "work_in_process_materials", "raw_materials"
  add_foreign_key "work_in_progress_materials", "raw_materials"
end
