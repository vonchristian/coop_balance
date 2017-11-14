class InterestPosting
  def post_interests_earned(savings_account)
    savings_account.entries.create!(entry_type: 'savings_interest',  description: 'Savings interest', entry_date: Time.zone.now,
    debit_amounts_attributes: [account: debit_account, amount: amount(savings_account)],
    credit_amounts_attributes: [account: credit_account, amount: amount(savings_account)])
  end
  def amount(savings_account)
    savings_account.balance * savings_account.saving_product_interest_rate
  end
  def debit_account
    CoopConfigurationsModule::SavingsAccountConfig.new.default_interest_account
  end
  def credit_account
    savings_account.saving_product_account
  end
end
