class LoanPrincipal
 def payments_total(loan)
    loan.loan_product.account.debits_balance(options)
  end

  def balance(loan)
    loan.loan_product.account.balance(commercial_document_id: loan.id)
  end

  def compute(loan, schedule)
    #compute daily loan penalty
    loan.unpaid_balance_for(schedule) * (rate / 30)
  end

  def rate
   loan.loan_product.interest_rate
  end
end
