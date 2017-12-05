class LoanPenalty
  def payments_total(loan)
    loan.entries.map{|a| a.credit_amounts.distinct.where(account: CoopConfigurationsModule::LoanPenaltyConfig.account_to_debit).sum(&:amount)}.sum
  end

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

