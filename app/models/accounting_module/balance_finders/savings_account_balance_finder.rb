module AccountingModule
  module BalanceFinders
    class SavingsAccountBalanceFinder
      attr_reader :commercial_document, :from_date, :to_date, :account, :interest_expense_account
      def initialize(args={})
        @commercial_document = args[:commercial_document]
        @from_date =args[:from_date]
        @to_date = args[:to_date]
        @account = args[:account]
        @interest_expense_account = args[:interest_expense_account]
      end
      def balance
        account.balance(commercial_document: commercial_document, from_date: from_date, to_date: to_date) +
        interest_expense_account.debits_balance(commercial_document: commercial_document, from_date: from_date, to_date: to_date)
      end
    end
  end
end
