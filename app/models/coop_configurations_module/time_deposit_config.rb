module CoopConfigurationsModule
  class TimeDepositConfig < ApplicationRecord
    belongs_to :break_contract_account, class_name: "AccountingModule::Account"
    belongs_to :interest_account,  class_name: "AccountingModule::Account"
    belongs_to :account, class_name: "AccountingModule::Account"

    validates :account_id, :interest_account_id, :break_contract_account_id, presence: true
    validates :break_contract_fee, presence: true, numericality: true
    def self.default_amount
      return self.last.break_contract_fee if self.any?
      100
    end

    def self.default_break_contract_account
      return self.last.break_contract_account if self.any?
      AccountingModule::Account.find_by(name: "Time Deposit Break Contract Fees")
    end

    def self.earned_interests_for(time_deposit)
      self.last.interest_account.balance(commercial_document: time_deposit)
    end
  end
end
