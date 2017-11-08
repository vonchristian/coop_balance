module CoopConfigurationsModule
  class LoanProtectionFundConfig < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    validates :account_id, presence: true
    def self.account_to_debit
      if self.last.present?
        CoopConfigurationsModule::LoanProtectionFundConfig.order(created_at: :asc).last.account
      else
        AccountingModule::Liability.find_by(name: 'Loan Protection Fund Payable')
      end
    end
  end
end
