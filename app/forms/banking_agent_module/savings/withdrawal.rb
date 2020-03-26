module BankingAgentModule
  module Savings
    class Withdrawal

      include ActiveModel::Model

      attr_accessor :amount, :reference_number, :description, :saving_id, :banking_agent_id, :cart_id, :account_number

      def process! 
        if valid?
          ApplicationRecord.transaction do 
            create_cart_amount 
          end 
        end 
      end 

      def create_cart_amount
        voucher = find_banking_agent.vouchers.build(
          account_number: account_number,
          date:             Date.current, 
          reference_number: reference_number,
          description:      description,
          payee:            find_saving.depositor, 
          recording_agent:  find_banking_agent,
          disbursing_agent: find_banking_agent
        )
        

        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_banking_agent.cash_account
        )

        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_office_depository_account
        )

        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_banking_agent.depository_account_for(clearing_house: find_clearing_house)
        )
        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_saving.liability_account
        )
        voucher.save!
      end 

      def find_saving 
        find_banking_agent.savings.find(saving_id)
      end 

      def find_clearing_house
        AutomatedClearingHouse.first
      end 

      def find_office_depository_account
        office = find_saving.office 

        office.depository_account_for(clearing_house: find_clearing_house)
      end 


      def find_banking_agent
        BankingAgent.find(banking_agent_id)
      end 
    end 
  end 
end 