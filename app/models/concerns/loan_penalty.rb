class LoanPenalty
  def payments_total(loan)
    loan.entries.map{|a| a.credit_amounts.distinct.where(account: loan.loan_product.penalty_account_id).sum(&:amount)}.sum
  end

  def balance(loan)
    loan.loan_product.penalty_account.balance(commercial_document_id: loan.id)
  end

  def compute(loan, schedule)
    #compute daily loan penalty
    loan.unpaid_balance_for(schedule) * (rate / 30)
  end

  def rate
   loan.loan_product.penalty_rate
  end
end

