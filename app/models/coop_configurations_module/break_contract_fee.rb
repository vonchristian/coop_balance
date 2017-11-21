module CoopConfigurationsModule
  class BreakContractFee < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"

    validates :amount, :account_id, presence: true
    validates :amount, numericality: true
    def self.default_amount
      order(created_at: :asc).last.amount
    end

    def self.default_account
      if self.exists?
        order(created_at: :asc).last.account
      else
        AccountingModule::Account.find_by(name: "Break Contract Fees")
      end
    end
  end
end
