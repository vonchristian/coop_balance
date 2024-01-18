module LoansModule
  module PastDuePercentage
    def past_due_percent(args = {})
      (past_due_accounts.balance(args) / accounts.balance(args)) * 100
    end
  end
end
