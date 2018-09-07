module Totalable
  def total_balances(args={})
    accounts.balance(args)
  end
  def total_debits_balance(args={})
    accounts.debits_balance(args)
  end
   def total_credits_balance(args={})
    accounts.credits_balance(args)
  end

end
