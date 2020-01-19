module LoansModule
  module Loans 
    class LoanAgingCreator 
      attr_reader :loan 

      def initialize(loan:)
        @loan = loan 
      end 

      def process!
        loan_aging = loan.loan_agings.build(
          loan_aging_group: loan_aging_group
        )
        create_receivable_account(loan_aging)
        loan_aging.save!
      end 

      private 

      def receivable_account(loan_aging)
        AccountCreators::Loans::LoanAgingReceivableAccount.new(loan_aging: loan_aging).create_receivable_account! 
      end 
    end 
  end 
end 