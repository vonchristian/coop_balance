module BankingAgentModule 
  module Savings 
    class DepositConfirmation 
      attr_reader :cart, :saving 

      def initialize(voucher:, saving:)
        @voucher = voucher  
        @saving  = saving 
      end 

      def confirm!
        create_entry 
      end 

      private 
      def create_entry 
        entry = find_banking_agent.entries.build(
          date: Date.current, 
          reference_number: voucher.reference_number,
          description: voucher.description) 

          entry.debit_amounts << voucher.voucher_amounts.debit 
          entry.credit_amounts << voucher.voucher_amounts.credit 

          entry.debit_amounts.build(account: depository_account(saving.office), amount: voucher.voucher_amounts.credit.total)
          entry.credit_amounts.build(account: depository_account(saving.office), amount: voucher.voucher_amounts.credit.total)
        entry.save!
      end 
    end 
  end 
end 
