coop = Cooperative.find_or_create_by(name: 'Ifugao Public Servants Multipurpose Cooperative', abbreviated_name: "IPSMPC", address: "Capitol Compound", contact_number: "0915-699-0481", registration_number: '12313213')
coop.accounts << AccountingModule::Account.all
office = coop.main_offices.find_or_create_by(name: "Main Offce", address: "Capitol Compound", contact_number: '23e2312')
general_manager = User.general_manager.create!(
  email: 'general_manager2@coopcatalyst.ph',
  password: '11111111',
  password_confirmation: '11111111',
  first_name: "General",
  last_name: "Manager",
  cooperative: coop,
  office: office)
genesis_account = coop.accounts.assets.find_or_create_by(name: "Genesis Account", active: false, code: "Genesis Code")
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

coop.share_capital_products.find_or_create_by!(
  name: "Paid-up Share Capital - Common",
  cost_per_share: 100,
  minimum_number_of_subscribed_share: 100,
  minimum_number_of_paid_share: 100,
  default_product: true,
  paid_up_account: share_capital_paid_up_common_account,
  subscription_account: subscribed_share_capital_commom_account
)

# Loan Products
loans_receivable_current_regular_account = AccountingModule::Account.find_by(name: "Loans Receivable - Current (Regular Loan)")
loans_receivable_past_due_regular_account = AccountingModule::Account.find_by(name: "Loans Receivable - Past Due (Regular Loan)")
interest_revenue_regular_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - Regular Loan")
unearned_interest_income_regular_account = AccountingModule::Account.find_by(name: "Unearned Interests - Regular Loan")
penalty_revenue_regular_account = AccountingModule::Account.find_by(name: "Loan Penalties Income - Regular Loan")

loans_receivable_current_emergency_account = AccountingModule::Account.find_by(name: "Loans Receivable - Current (Emergency Loan)")
loans_receivable_past_due_emergency_account = AccountingModule::Account.find_by(name: "Loans Receivable - Past Due (Emergency Loan)")
interest_revenue_emergency_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - Emergency Loan")
unearned_interest_income_emergency_account = AccountingModule::Account.find_by(name: "Unearned Interests - Emergency Loan")
penalty_revenue_emergency_account = AccountingModule::Account.find_by(name: "Loan Penalties Income - Emergency Loan")

loans_receivable_current_short_term_account = AccountingModule::Account.find_by(name: "Loans Receivable - Current (Short-Term Loan)")
loans_receivable_past_due_short_term_account = AccountingModule::Account.find_by(name: "Loans Receivable - Past Due (Short-Term Loan)")
interest_revenue_short_term_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - Short-Term Loan")
unearned_interest_income_short_term_account = AccountingModule::Account.find_by(name: "Unearned Interests - Short-Term Loan")
penalty_revenue_short_term_account = AccountingModule::Account.find_by(name: "Loan Penalties Income - Short-Term Loan")

loans_receivable_current_productive_account = AccountingModule::Account.find_by(name: "Loans Receivable - Current (Productive Loan)")
loans_receivable_past_due_productive_account = AccountingModule::Account.find_by(name: "Loans Receivable - Past Due (Productive Loan)")
interest_revenue_productive_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - Productive Loan")
unearned_interest_income_productive_account = AccountingModule::Account.find_by(name: "Unearned Interests - Productive Loan")
penalty_revenue_productive_account = AccountingModule::Account.find_by(name: "Loan Penalties Income - Productive Loan")

# Loan Product (Regular Loan)
regular_loan_product = coop.loan_products.find_or_create_by!(
  name: "Regular Loan",
  description: "",
  maximum_loanable_amount: 300000.00,
  loans_receivable_current_account: loans_receivable_current_regular_account,
  loans_receivable_past_due_account: loans_receivable_past_due_regular_account
)

regular_loan_product.interest_configs.find_or_create_by(
  rate: 0.12,
  interest_revenue_account: interest_revenue_regular_account,
  unearned_interest_income_account: unearned_interest_income_regular_account
)

regular_loan_product.penalty_configs.find_or_create_by(
  rate: 0.01,
  penalty_revenue_account: penalty_revenue_regular_account
)

# Loan Product (Emergency Loan)
emergency_loan_product = coop.loan_products.find_or_create_by!(
  name: "Emergency Loan",
  description: "",
  maximum_loanable_amount: 300000.00,
  loans_receivable_current_account: loans_receivable_current_emergency_account,
  loans_receivable_past_due_account: loans_receivable_past_due_emergency_account
)

emergency_loan_product.interest_configs.find_or_create_by(
  rate: 0.03,
  interest_revenue_account: interest_revenue_regular_account,
  unearned_interest_income_account: unearned_interest_income_emergency_account
)

emergency_loan_product.penalty_configs.find_or_create_by(
  rate: 0.01,
  penalty_revenue_account: penalty_revenue_emergency_account
)

# Loan Product (Short-Term Loan) Member
member_short_term_loan = coop.loan_products.find_or_create_by!(
  name: "Short-Term Loan(Member)",
  description: "",
  maximum_loanable_amount: 100000.00,
  loans_receivable_current_account: loans_receivable_current_short_term_account,
  loans_receivable_past_due_account: loans_receivable_past_due_short_term_account
)

member_short_term_loan.interest_configs.find_or_create_by(
  rate: 0.025,
  interest_revenue_account: interest_revenue_short_term_account,
  unearned_interest_income_account: unearned_interest_income_short_term_account
)

member_short_term_loan.penalty_configs.find_or_create_by(
  rate: 0.01,
  penalty_revenue_account: penalty_revenue_short_term_account
)

# Loan Product (Short-Term Loan) Non-Member
non_member_short_term_loan = coop.loan_products.find_or_create_by!(
  name: "Short-Term Loan(Non-Member)",
  description: "",
  maximum_loanable_amount: 100000.00,
  loans_receivable_current_account: loans_receivable_current_short_term_account,
  loans_receivable_past_due_account: loans_receivable_past_due_short_term_account
)

non_member_short_term_loan.interest_configs.find_or_create_by(
  rate: 0.03,
  interest_revenue_account: interest_revenue_short_term_account,
  unearned_interest_income_account: unearned_interest_income_short_term_account
)

non_member_short_term_loan.penalty_configs.find_or_create_by(
  rate: 0.01,
  penalty_revenue_account: penalty_revenue_short_term_account
)

# Loan Product (productive Loan)
# Productive Loan - Swine Raising(40,000-100,000)
productive_loan = coop.loan_products.find_or_create_by!(
  name: "Productive Loan",
  description: "",
  maximum_loanable_amount: 100000.00,
  loans_receivable_current_account: loans_receivable_current_productive_account,
  loans_receivable_past_due_account: loans_receivable_past_due_productive_account
)

productive_loan.interest_configs.find_or_create_by(
  rate: 0.1,
  interest_revenue_account: interest_revenue_productive_account,
  unearned_interest_income_account: unearned_interest_income_productive_account
)

productive_loan.penalty_configs.find_or_create_by(
  rate: 0.02,
  penalty_revenue_account: penalty_revenue_productive_account
)

# Time Deposit
time_deposit_account = AccountingModule::Account.find_by(name: "Time Deposits")
time_deposit_interest_expense_account = AccountingModule::Account.find_by(name: "Interest Expense on Time Deposits")
time_deposit_break_contract_account = AccountingModule::Account.find_by(name: "Time Deposit Break Contract Fees")

# 90-Days TD(10,000 - 99,999)
coop.time_deposit_products.find_or_create_by!(
  name: "90 Days Regular Time Deposit(10,000 - 99,999)",
  minimum_deposit: 10000.00,
  maximum_deposit: 99999.00,
  interest_rate: 0.04,
  number_of_days: 90,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 90-Days TD(100,000 - 199,999)
coop.time_deposit_products.find_or_create_by!(
  name: "90 Days Regular Time Deposit(100,000 - 199,999)",
  minimum_deposit: 100000.00,
  maximum_deposit: 199999.00,
  interest_rate: 0.04,
  number_of_days: 90,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 90-Days TD(200,000 - above)
coop.time_deposit_products.find_or_create_by!(
  name: "90 Days Regular Time Deposit(200,000 - above)",
  minimum_deposit: 200000.00,
  maximum_deposit: 999999999.00,
  interest_rate: 0.04,
  number_of_days: 90,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 180-Days TD(10,000 - 99,999)
coop.time_deposit_products.find_or_create_by!(
  name: "180 Days Regular Time Deposit(10,000 - 99,999)",
  minimum_deposit: 10000.00,
  maximum_deposit: 99999.00,
  interest_rate: 0.045,
  number_of_days: 180,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 180-Days TD(100,000 - 199,999)
coop.time_deposit_products.find_or_create_by!(
  name: "180 Days Regular Time Deposit(100,000 - 199,999)",
  minimum_deposit: 100000.00,
  maximum_deposit: 199999.00,
  interest_rate: 0.05,
  number_of_days: 180,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 180-Days TD(200,000 - above)
coop.time_deposit_products.find_or_create_by!(
  name: "180 Days Regular Time Deposit(200,000 - above)",
  minimum_deposit: 200000.00,
  maximum_deposit: 999999999.00,
  interest_rate: 0.055,
  number_of_days: 180,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 360-Days TD(10,000 - 99,999)
coop.time_deposit_products.find_or_create_by!(
  name: "360 Days Regular Time Deposit(10,000 - 99,999)",
  minimum_deposit: 10000.00,
  maximum_deposit: 99999.00,
  interest_rate: 0.05,
  number_of_days: 360,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 360-Days TD(100,000 - 199,999)
coop.time_deposit_products.find_or_create_by!(
  name: "360 Days Regular Time Deposit(100,000 - 199,999)",
  minimum_deposit: 100000.00,
  maximum_deposit: 199999.00,
  interest_rate: 0.055,
  number_of_days: 360,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# 360-Days TD(200,000 - above)
coop.time_deposit_products.find_or_create_by!(
  name: "360 Days Regular Time Deposit(200,000 - above)",
  minimum_deposit: 200000.00,
  maximum_deposit: 999999999.00,
  interest_rate: 0.06,
  number_of_days: 360,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

coop.time_deposit_products.find_or_create_by!(
  name: "2 Years Special Time Deposit(1,000,000 and above)",
  minimum_deposit: 1000000.00,
  maximum_deposit: 999999990.00,
  interest_rate: 0.07,
  number_of_days: 720,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

coop.time_deposit_products.find_or_create_by!(
  name: "3 Years Special Time Deposit(1,000,000 and above)",
  minimum_deposit: 1000000.00,
  maximum_deposit: 999999990.00,
  interest_rate: 0.08,
  number_of_days: 1080,
  account: time_deposit_account,
  interest_expense_account: time_deposit_interest_expense_account,
  break_contract_account: time_deposit_break_contract_account,
  break_contract_fee: 0.00,
  break_contract_rate: 0.00
)

# Saving Products
savings_account = AccountingModule::Account.find_by(name: "Savings Deposits")
savings_interest_expense_account = AccountingModule::Account.find_by(name: "Interest Expense on Savings Deposits")
savings_closing_account = AccountingModule::Account.find_by(name: "Savings Account Closing Fees")

coop.saving_products.find_or_create_by!(
  name: "Regular Savings Deposit",
  interest_rate: 0.03,
  interest_recurrence: "monthly",
  account: savings_account,
  interest_expense_account: savings_interest_expense_account,
  closing_account: savings_closing_account,
  minimum_balance: 500
)
