class LoanPenalty
   def balance(loan)
    CoopConfigurationsModule::LoanPenaltyConfig.balance_for(loan)
  end
  def compute(loan, schedule)
    #compute daily loan penalty
    loan.unpaid_balance_for(schedule) * (rate / 30)
  end
  def rate
    CoopConfigurationsModule::LoanPenaltyConfig.default_rate
  end
end

