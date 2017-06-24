class InterestPosting
  def post_interests_earned(savings_account)
    savings_account.entries.create!(entry_type: 'savings_interest',  description: 'Savings interest', entry_date: Time.zone.now,
    debit_amounts_attributes: [account: debit_account, amount: amount(savings_account)],
    credit_amounts_attributes: [account: credit_account, amount: amount(savings_account)])
  end
  def amount(savings_account)
    savings_account.balance * savings_account.saving_product.interest_rate 
  end
  def debit_account
    AccountingDepartment::Account.find_by(name: "Interest Expense on Deposits")
  end
  def credit_account
    AccountingDepartment::Account.find_by(name: "Savings Deposits")
  end
end 