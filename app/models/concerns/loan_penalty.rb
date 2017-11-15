class LoanPenalty
   def balance(borrower)
    CoopConfigurationsModule::LoanPenaltyConfig.balance_for(borrower) +
    borrower.loans.disbursed.map{|a| a.penalty_payment_total }.sum
  end
  def compute(loan, schedule)
    #compute daily loan penalty
    loan.unpaid_balance_for(schedule) * (rate / 30)
  end
  def rate
    CoopConfigurationsModule::LoanPenaltyConfig.default_rate
  end
end

