module CoopConfigurationsModule
  class SavingsAccountConfig < ApplicationRecord
    belongs_to :closing_account, class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"

    validates :closing_account_fee, :number_of_days_to_be_dormant, numericality: true, presence: true
    validates :closing_account_id,  presence: true
    def self.default_closing_account_fee
      if self.exists?
        order(created_at: :asc).last.closing_account_fee
      else
        150
      end
    end

    def self.default_closing_account
      return last.closing_account if self.any?
      AccountingModule::Revenue.find_by_name("Closing Account Fees")
    end

    def default_number_of_days_to_be_dormant
      order(created_at: :asc).last.try(:number_of_days_to_be_dormant) || NullDormantCount.new.number_of_days_to_be_dormant
    end


    def default_interest_account
      if interest_account.present?
        interest_account
      else
        AccountingModule::Account.find_by(name: "Interest Expense on Savings Deposits")
      end
    end
  end
end
