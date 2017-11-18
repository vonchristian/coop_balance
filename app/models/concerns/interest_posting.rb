class InterestPosting
  def post_interests_earned(savings_account, posting_date)
    savings_account.entries.create!(entry_type: 'savings_interest',  description: 'Savings interest', entry_date: posting_date,
    debit_amounts_attributes: [account: debit_account, amount: amount_for(savings_account)],
    credit_amounts_attributes: [account: credit_account, amount: amount_for(savings_account)])
  end

  def amount_for(savings_account)
    savings_account.balance * savings_account.saving_product_interest_rate * (number_of_days_in_quarter(posting_date) / 365)
  end
  def debit_account
    CoopConfigurationsModule::SavingsAccountConfig.new.default_interest_account
  end
  def credit_account
    savings_account.saving_product_account
  end
  def number_of_days_in_quarter(posting_date)
    ((posting_date.end_of_quarter - posting_date.beginning_of_quarter)/86400.0).to_i
  end
end
