module LoansModule
  class LoanProtectionFund < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :loan
    belongs_to :loan_protection_rate
    has_one :loan_charge, as: :chargeable
    after_commit :set_loan_charge
    def name
      "Loan Protection Fund"
    end
    def percent_type?
      false
    end
    def regular?
      false
    end
    def self.account_to_debit
      if CoopConfigurationsModule::LoanProtectionFundConfig.last.present?
        CoopConfigurationsModule::LoanProtectionFundConfig.order(created_at: :asc).last.account
      else
        AccountingModule::Liability.find_by(name: 'Loan Protection Fund Payable')
      end
    end
    def self.rate_for(loan)
      LoanProtectionRate.rate_for(loan)
    end
    def self.set_amount_for(loan)
      if !loan.disbursed?
        number_of_thousands = loan.loan_amount / 1_000
        number_of_thousands * self.rate_for(loan) * loan.term
      elsif loan.disbursed?
        number_of_thousands = loan.balance / 1_000
        number_of_thousands * self.rate_for(loan) * loan.remaining_term
      end
    end
    def self.set_loan_protection_fund_for(loan)
      loan_protection = loan.loan_protection_funds.create(amount: set_amount_for(loan), account: account_to_debit)
      loan.loan_charges.find_or_create_by(chargeable: loan_protection)
    end

    private
    def set_loan_charge
      self.create_loan_charge(chargeable: self, loan: self.loan)
    end
  end
end
