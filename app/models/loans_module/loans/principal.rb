module LoansModule
  module Loans
    module Principal
      def principal_balance(args = {})
        receivable_account.balance(args)
      end

      def principal_debits_balance(args = {})
        receivable_account.debits_balance(args)
      end

      def principal_credits_balance(args = {})
        receivable_account.credits_balance(args)
      end
    end
  end
end
