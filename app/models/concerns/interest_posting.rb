class InterestPosting
  def post_interests_earned(savings_account, posting_date)
    if !savings_account.interest_posted?(posting_date)
      savings_account.entries.create!(description: 'Savings interest', entry_date: posting_date,
      debit_amounts_attributes: [account: debit_account(savings_account), amount: amount_for(savings_account, posting_date), commercial_document: savings_account],
      credit_amounts_attributes: [account: credit_account(savings_account), amount: amount_for(savings_account, posting_date), commercial_document: savings_account])
    end
  end

  def amount_for(savings_account, posting_date)
    savings_account.balance * savings_account.saving_product_interest_rate * (number_of_days(posting_date, savings_account.saving_product) / 365)
  end

  def debit_account(savings_account)
   savings_account.saving_product_interest_expense_account
  end
  def credit_account(savings_account)
    savings_account.saving_product_account
  end
  def number_of_days(posting_date, saving_product)
    if saving_product.quarterly?
      ((posting_date.end_of_quarter - posting_date.beginning_of_quarter)/86400.0).to_i
    elsif saving_product.annually?
      ((posting_date.end_of_year - posting_date.beginning_of_year)/86400.0).to_i
    end
  end
end
