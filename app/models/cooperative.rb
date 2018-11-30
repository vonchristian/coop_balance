class Cooperative < ApplicationRecord
  has_one_attached :logo
  has_many :offices,                class_name: "CoopConfigurationsModule::Office"
  has_many :main_offices,           class_name: "CoopConfigurationsModule::Offices::MainOffice"
  has_many :cooperative_services,   class_name: "CoopServicesModule::CooperativeService"
  has_many :store_fronts,           as: :business
  has_many :accountable_accounts,   as: :accountable, class_name: "AccountingModule::AccountableAccount"
  has_many :accounts,               through: :accountable_accounts, class_name: "AccountingModule::Account"
  has_many :memberships
  has_many :member_memberships,     through: :memberships, source: :cooperator, source_type: 'Member'
  has_many :bank_accounts
  has_many :loans,                  class_name: "LoansModule::Loan"
  has_many :entries,                class_name: "AccountingModule::Entry"
  has_many :amounts,                class_name: "AccountingModule::Amount", through: :entries
  has_many :debit_amounts,          class_name: "AccountingModule::DebitAmount", through: :entries
  has_many :credit_amounts,         class_name: "AccountingModule::CreditAmount", through: :entries

  has_many :organizations
  has_many :vouchers
  has_many :voucher_amounts,        class_name: "Vouchers::VoucherAmount"
  has_many :users
  has_many :saving_products,        class_name: "CoopServicesModule::SavingProduct"
  has_many :loan_products,          class_name: "LoansModule::LoanProduct"
  has_many :time_deposit_products,  class_name: "CoopServicesModule::TimeDepositProduct"
  has_many :share_capital_products, class_name: "CoopServicesModule::ShareCapitalProduct"
  has_many :programs,               class_name: "CoopServicesModule::Program"
  has_many :savings,                class_name: "MembershipsModule::Saving"
  has_many :share_capitals,         class_name: "MembershipsModule::ShareCapital"
  has_many :time_deposits,          class_name: "MembershipsModule::TimeDeposit"
  has_many :barangays,              class_name: "Addresses::Barangay"
  has_many :municipalities,         class_name: "Addresses::Municipality"
  has_many :loan_applications,      class_name: "LoansModule::LoanApplication"
  has_many :employee_cash_accounts, class_name: "Employees::EmployeeCashAccount"
  has_many :cash_accounts,          through: :employee_cash_accounts, source: :cash_account, class_name: "AccountingModule::Account"
  has_many :amortization_schedules, class_name: "LoansModule::AmortizationSchedule"
  has_many :registries
  has_many :loan_registries,         class_name: "Registries::LoanRegistry"
  has_many :member_registries,       class_name: "Registries::MemberRegistry"
  has_many :savings_account_registries,       class_name: "Registries::SavingsAccountRegistry"
  has_many :share_capital_registries,       class_name: "Registries::ShareCapitalRegistry"
  has_many :time_deposit_registries,       class_name: "Registries::TimeDepositRegistry"
  has_many :beneficiaries
  has_many :savings_account_applications
  has_many :share_capital_applications
  has_many :time_deposit_applications
  has_many :branch_offices, class_name: "CoopConfigurationsModule::Offices::BranchOffice"
  has_many :satellite_offices, class_name: "CoopConfigurationsModule::Offices::SatelliteOffice"
  has_many :suppliers
  has_many :products, class_name: "StoreFrontModule::Product"
  has_many :purchase_line_items, class_name: "StoreFrontModule::LineItems::PurchaseLineItem"

  validates :name, :abbreviated_name, presence: true
  validates :name, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true
  def avatar
    logo
  end
end
