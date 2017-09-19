class LoanPenaltyService
  def self.post_penalty_for(loan, date)
    AccountingModule::Entry.loan_penalty.create(commercial_document: loan, description: 'Loan penalties', entry_date: Time.zone.now,
      debit_amounts_attributes: [amount: penalty_for(loan, date), account: debit_account],
      credit_amounts_attributes: [amount: penalty_for(loan, date), account: credit_account])
  end

  def self.penalty_amount(loan)
  end
  def self.debit_account
    AccountingModule::Account.find_by(name: 'Accounts Receivables - Loan Penalties')
  end
  def self.credit_account 
    AccountingModule::Account.find_by(name: 'Loan Penalties')
  end
  def self.penalty_for(loan, date)
    loan.total_unpaid_principal_for(date) * interest_rate
  end
  def self.interest_rate
    interest_rate = CoopConfigurationsModule::LoanPenaltyConfig.last.interest_rate
    if interest_rate.present?
      interest_rate
    else 
      0.01
    end 
  end 
end