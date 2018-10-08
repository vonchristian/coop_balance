class Cooperative < ApplicationRecord
  has_one_attached :logo
  belongs_to :interest_amortization_config
  has_many :offices, class_name: "CoopConfigurationsModule::Office"
  has_many :cooperative_services, class_name: "CoopServicesModule::CooperativeService"
  has_many :store_fronts, as: :business
  has_many :accountable_accounts, as: :accountable, class_name: "AccountingModule::AccountableAccount"
  has_many :accounts, through: :accountable_accounts, class_name: "AccountingModule::Account"
  has_many :memberships
  has_many :member_memberships, through: :memberships, source: :cooperator, source_type: 'Member'
  has_many :bank_accounts
  has_many :loans, class_name: "LoansModule::Loan"
  has_many :vouchers
  validates :name, :abbreviated_name, presence: true
  validates :name, uniqueness: true
  validates :registration_number, presence: true, uniqueness: true

end
