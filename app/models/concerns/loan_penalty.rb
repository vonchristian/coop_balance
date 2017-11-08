class LoanPenalty
   def balance(borrower)
    CoopConfigurationsModule::LoanPenaltyConfig.balance_for(borrower) +
    borrower.loans.disbursed.map{|a| a.penalty_payment_total }.sum
  end
  def compute(loan, schedule)
    loan.unpaid_balance_for(schedule) * rate
  end
  def rate
    0.02
  end
end

