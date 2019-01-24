class LoanProductInterestCalculation < ApplicationRecord
  enum calculation_type: [:prededucted, :add_on, :unearned]

  def payment_processor
    ("LoansModule::PaymentProcessors::" + calculation_type.titleize.gsub(" ", "")+"Interest").constantize
  end
end
