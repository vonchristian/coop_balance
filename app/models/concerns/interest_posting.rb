class InterestPosting
  def post_interests_earned(posting_date, employee)
    entry = AccountingModule::Entry.new(
    commercial_document: employee,
    origin: employee.office,
    recorder: employee,
    description: 'Interest expense on savings deposits',
    entry_date: posting_date)
    MembershipsModule::Saving.has_minimum_balance.each do |savings_account|
      if !savings_account.interest_posted?(posting_date)
        debit_amount = AccountingModule::DebitAmount.new(
        account: debit_account(savings_account),
        amount: amount_for(savings_account, posting_date))
        credit_amount = AccountingModule::CreditAmount.new(
        account: debit_account(savings_account),
        amount: amount_for(savings_account, posting_date))
        entry.debit_amounts << debit_amount
        entry.credit_amounts << credit_amount
      end
    end
    entry.save
  end

  def amount_for(savings_account, posting_date)
    savings_account.average_daily_balance(date: posting_date) *
    savings_account.saving_product_interest_rate
  end

  def debit_account(savings_account)
   savings_account.saving_product_interest_expense_account
  end

  def credit_account(savings_account)
    savings_account.saving_product_account
  end
end
