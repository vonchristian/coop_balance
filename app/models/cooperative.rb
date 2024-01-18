class Cooperative < ApplicationRecord
  has_one_attached :logo
  has_many :offices,                        class_name: 'Cooperatives::Office'
  has_many :main_offices,                   class_name: 'Cooperatives::Offices::MainOffice'
  has_many :branch_offices,                 class_name: 'Cooperatives::Offices::BranchOffice'
  has_many :satellite_offices,              class_name: 'Cooperatives::Offices::SatelliteOffice'
  has_many :cooperative_services,           class_name: 'CoopServicesModule::CooperativeService'
  has_many :store_fronts
  has_many :accountable_accounts,           as: :accountable, class_name: 'AccountingModule::AccountableAccount'
  has_many :accounts,                       through: :accountable_accounts, class_name: 'AccountingModule::Account'
  has_many :memberships,                    class_name: 'Cooperatives::Membership'
  has_many :member_memberships,             through: :memberships, source: :cooperator, source_type: 'Member'
  has_many :bank_accounts
  has_many :loans,                          class_name: 'LoansModule::Loan'
  has_many :entries,                        class_name: 'AccountingModule::Entry'
  has_many :amounts,                        class_name: 'AccountingModule::Amount', through: :entries
  has_many :debit_amounts,                  class_name: 'AccountingModule::DebitAmount', through: :entries
  has_many :credit_amounts,                 class_name: 'AccountingModule::CreditAmount', through: :entries
  has_many :organizations
  has_many :vouchers
  has_many :voucher_amounts, class_name: 'Vouchers::VoucherAmount'
  has_many :users
  has_many :saving_products,                class_name: 'SavingsModule::SavingProduct'
  has_many :loan_products,                  class_name: 'LoansModule::LoanProduct'
  has_many :interest_configs,               through: :loan_products
  has_many :time_deposit_products,          class_name: 'CoopServicesModule::TimeDepositProduct'
  has_many :share_capital_products,         class_name: 'Cooperatives::ShareCapitalProduct'
  has_many :programs,                       class_name: 'Cooperatives::Program'
  has_many :program_subscriptions,          through: :programs, class_name: 'MembershipsModule::ProgramSubscription'
  has_many :savings,                        class_name: 'DepositsModule::Saving'
  has_many :share_capitals,                 class_name: 'DepositsModule::ShareCapital'
  has_many :time_deposits,                  class_name: 'DepositsModule::TimeDeposit'
  has_many :barangays,                      class_name: 'Addresses::Barangay'
  has_many :municipalities,                 class_name: 'Addresses::Municipality'
  has_many :loan_applications,              class_name: 'LoansModule::LoanApplication'
  has_many :employee_cash_accounts,         class_name: 'Employees::EmployeeCashAccount'
  has_many :cash_accounts,                  class_name: 'AccountingModule::Account', through: :employee_cash_accounts, source: :cash_account
  has_many :amortization_schedules,         class_name: 'LoansModule::AmortizationSchedule'
  has_many :registries
  has_many :loan_registries,                class_name: 'Registries::LoanRegistry'
  has_many :stock_registries,               class_name: 'Registries::StockRegistry'
  has_many :program_subscription_registries, class_name: 'Registries::ProgramSubscriptionRegistry'
  has_many :member_registries,              class_name: 'Registries::MemberRegistry'
  has_many :savings_account_registries,     class_name: 'Registries::SavingsAccountRegistry'
  has_many :share_capital_registries,       class_name: 'Registries::ShareCapitalRegistry'
  has_many :time_deposit_registries,        class_name: 'Registries::TimeDepositRegistry'
  has_many :bank_account_registries,        class_name: 'Registries::BankAccountRegistry'
  has_many :organization_registries,        class_name: 'Registries::OrganizationRegistry'
  has_many :categories,                     class_name: 'StoreFrontModule::Category'
  has_many :beneficiaries
  has_many :savings_account_applications
  has_many :share_capital_applications,     class_name: 'ShareCapitalsModule::ShareCapitalApplication'
  has_many :time_deposit_applications,      class_name: 'TimeDepositsModule::TimeDepositApplication'
  has_many :suppliers,                      class_name: 'StoreFrontModule::Supplier'
  has_many :products,                       class_name: 'StoreFrontModule::Product'
  has_many :purchase_line_items,            class_name: 'StoreFrontModule::LineItems::PurchaseLineItem'
  has_many :sales_orders,                   class_name: 'StoreFrontModule::Orders::SalesOrder'
  has_many :loan_protection_plan_providers, class_name: 'LoansModule::LoanProtectionPlanProvider'
  has_many :net_income_distributions
  # has_many :account_categories,             class_name: 'AccountingModule::AccountCategory'
  has_many :membership_categories

  validates :name, :abbreviated_name, presence: true
  validates :name, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true

  def avatar
    logo
  end

  def loan_product_current_accounts
    AccountingModule::Account.where(id: loan_products.pluck(:current_account_id))
  end
end
