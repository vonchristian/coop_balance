coop = Cooperative.find_or_create_by(name: 'Ifugao Public Servants Multipurpose Cooperative', abbreviated_name: "IPSMPC", address: "Capitol Compound", contact_number: "0915-699-0481", registration_number: '12313213')
coop.accounts << AccountingModule::Account.all
office = coop.main_offices.create(name: "Main Offce", address: "Capitol Compound", contact_number: '23e2312')
general_manager = User.general_manager.create!(
  email: 'general_manager2@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  cooperative: coop,
  office: office)
genesis_account = coop.accounts.assets.create(name: "Genesis Account", active: false, code: "Genesis Code")
  origin_entry = coop.entries.new(
    office:              office,
    cooperative:         coop,
    commercial_document: coop,
    description:         "Genesis entry",
    recorder:            general_manager,
    reference_number:    "Genesis",
    previous_entry_id:   "",
    previous_entry_hash:   "Genesis previous entry hash",
    encrypted_hash:      "Genesis encrypted hash",
    entry_date:          Date.today)
    origin_entry.debit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: coop)
    origin_entry.credit_amounts.build(
        account: genesis_account,
        amount: 0,
        commercial_document: coop)
  origin_entry.save!

# Share Capital Products
share_capital_paid_up_common_account = AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
subscribed_share_capital_commom_account = AccountingModule::Account.find_by(name: "Subscribed Share Capital - Common")

coop.share_capital_products.create!(
  name: "Share Capital - Common",
  cost_per_share: 100,
  minimum_number_of_subscribed_share: 200,
  minimum_number_of_paid_share: 200,
  default_product: true,
  paid_up_account: share_capital_paid_up_common_account,
  subscription_account: subscribed_share_capital_commom_account
)

# Loan Products
loans_receivable_current_regular_account = AccountingModule::Account.find_by(name: "Loans Receivable - Current (Regular Loan)")
loans_receivable_past_due_regular_account = AccountingModule::Account.find_by(name: "Loans Receivable - Past Due (Regular Loan)")
interest_revenue_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - Regular Loan")
unearned_interest_income_account = AccountingModule::Account.find_by(name: "Unearned Interests - Regular Loan")
penalty_revenue_account = AccountingModule::Account.find_by(name: "Loan Penalties Income - Regular Loan")

regular_loan_product = coop.loan_products.create!(
  name: "Regular Loan",
  description: "",
  maximum_loanable_amount: 20000.00,
  loans_receivable_current_account: loans_receivable_current_regular_account,
  loans_receivable_past_due_account: loans_receivable_past_due_regular_account
)

regular_loan_product.interest_configs.create(
  rate: 0.12,
  interest_revenue_account: interest_revenue_account,
  unearned_interest_income_account: unearned_interest_income_account
)

regular_loan_product.penalty_configs.create(
  rate: 0.03,
  penalty_revenue_account: penalty_revenue_account
)

# Time Deposit
time_deposit_account = AccountingModule::Account.find_by(name: "Time Deposits")
time_deposit_interest_expense_account = AccountingModule::Account.find_by(name: "Interest Expense on Time Deposits")
time_deposit_break_contract_account = AccountingModule::Account.find_by(name: "Time Deposit Break Contract Fees")

coop.time_deposit_products.create!(
  name: "Time Deposit - 180 Days",
  minimum_deposit: 100000.00,
  maximum_deposit: 10000000.00,
  interest_rate: 0.05,
  number_of_days: 180,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 100,
  break_contract_rate: 0.03
)

# Saving Products
savings_account = AccountingModule::Account.find_by(name: "Savings Deposits")
savings_interest_expense_account = AccountingModule::Account.find_by(name: "Interest Expense on Savings Deposits")
savings_closing_account = AccountingModule::Account.find_by(name: "Savings Account Closing Fees")

coop.saving_products.create!(
  name: "Regular Savings Deposit",
  interest_rate: 0.05,
  interest_recurrence: "monthly",
  account: savings_account,
  interest_expense_account: savings_interest_expense_account,
  closing_account: savings_closing_account,
  minimum_balance: 100
)