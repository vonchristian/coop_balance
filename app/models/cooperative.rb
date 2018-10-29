class Cooperative < ApplicationRecord
  has_one_attached :logo
  belongs_to :interest_amortization_config
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
  has_many :organizations
  has_many :vouchers
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

  validates :name, :abbreviated_name, presence: true
  validates :name, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true

end
