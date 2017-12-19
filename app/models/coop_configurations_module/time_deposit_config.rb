module CoopConfigurationsModule
  class TimeDepositConfig < ApplicationRecord
    belongs_to :break_contract_account, class_name: "AccountingModule::Account"
    belongs_to :interest_account,  class_name: "AccountingModule::Account"
    belongs_to :account, class_name: "AccountingModule::Account"

    validates :account_id, :interest_account_id, :break_contract_account_id, presence: true
    validates :break_contract_fee, presence: true, numericality: true
  end
end
