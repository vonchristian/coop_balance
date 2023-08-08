class BankingAgent < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable, :confirmable

  belongs_to :cash_account,             class_name: "AccountingModule::Account"
  has_many :cooperative_banking_agents, class_name: "Cooperatives::CooperativeBankingAgent"
  has_many :cooperatives,               through: :cooperative_banking_agents
  has_many :savings,                    class_name: "DepositsModule::Saving",       through: :cooperatives
  has_many :share_capitals,             class_name: "DepositsModule::ShareCapital", through: :cooperatives
  has_many :loans,                      class_name: "LoansModule::Loan",               through: :cooperatives
  has_many :entries,                    class_name: "AccountingModule::Entry", as: :origin
  has_many :recorded_entries,           class_name: "AccountingModule::Entry", as: :recording_agent
  has_many :vouchers,                   as: :origin
  has_many :recorded_vouchers,          class_name: "Voucher", as: :recording_agent
  has_many :carts,                      class_name: "BankingAgentModule::BankingAgentCart"
  has_many :clearing_house_depository_accounts, class_name: "ClearingHouseModule::ClearingHouseDepositoryAccount", as: :depositor
  validates :name, :account_number,     presence: true, uniqueness: true

  def depository_account_for(clearing_house:)
    clearing_house_depository_accounts.find_by!(clearing_house: clearing_house).depository_account
  end

end
