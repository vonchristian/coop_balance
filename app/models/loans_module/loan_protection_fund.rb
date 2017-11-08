module LoansModule
  class LoanProtectionFund < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :loan
    belongs_to :loan_protection_rate
    has_one :loan_charge, as: :chargeable
    # def name
    #   "Loan Protection Fund"
    # end
    # def percent_type?
    #   false
    # end
    # def regular?
    #   false
    # end
    def paid?
      loan.entries.map{|a| a.credit_amounts.distinct.where(account: CoopConfigurationsModule::LoanProtectionFundConfig.account_to_debit) }.present?
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
      loan_protection = Charge.create(name: "Loan Protection Fund", amount: set_amount_for(loan), account: CoopConfigurationsModule::LoanProtectionFundConfig.account_to_debit)
      loan.loan_charges.find_or_create_by(chargeable: loan_protection)
    end
  end
end
