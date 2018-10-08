class LoanProtectionFund < ApplicationRecord
  def self.compute_amount(loan_application)
    1.35 * loan_application.number_of_thousands * loan_application.term
  end
end
