module BankingAgentModule
  module ShareCapitals
    class CapitalBuildUp

      include ActiveModel::Model

      attr_accessor :amount, :reference_number, :description, :share_capital_id, :banking_agent_id, :cart_id, :account_number

      def process! 
        if valid?
          ApplicationRecord.transaction do 
            create_voucher
          end 
        end 
      end 
      private 

      def create_voucher
        voucher = find_banking_agent.vouchers.build(
          account_number: account_number,
          date:             Date.current, 
          reference_number: reference_number,
          description:      description,
          payee:            find_share_capital.subscriber, 
          recording_agent:  find_banking_agent,
          disbursing_agent: find_banking_agent
        )
        

        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_banking_agent.cash_account
        )

        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_office_depository_account
        )

        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_banking_agent.depository_account_for(clearing_house: find_clearing_house)
        )
        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_share_capital.share_capital_equity_account
        )
        voucher.save!
      end 

      def find_share_capital
        find_banking_agent.share_capitals.find(share_capital_id)
      end 

      def find_clearing_house
        AutomatedClearingHouse.first
      end 

      def find_office_depository_account
        office = find_share_capital.office 

        office.depository_account_for(clearing_house: find_clearing_house)
      end 


      def find_banking_agent
        BankingAgent.find(banking_agent_id)
      end 
    end 
  end 
end 