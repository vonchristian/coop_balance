module LoansModule
  module Loans
    module Principal
      def principal_balance(args={})
        principal_account.balance(args.merge(commercial_document: self))
      end

      def principal_debits_balance(args={})
        principal_account.debits_balance(args.merge(commercial_document: self))
      end

      def principal_credits_balance(args={})
        principal_account.credits_balance(args.merge(commercial_document: self))
      end
    end
  end
end
