module BankingAgentModule
  module UtilityBills
    class Payment

      include ActiveModel::Model

      attr_accessor :amount, :reference_number, :description, :utility_bill_id, :banking_agent_id, :cart_id, :account_number

      def process! 
        if valid?
          ApplicationRecord.transaction do 
            create_voucher
          end 
        end 
      end 

      def create_voucher
        voucher = find_banking_agent.vouchers.build(
          account_number: account_number,
          date:             Date.current, 
          reference_number: reference_number,
          description:      description,
          payee:            find_utility_bill.payee, 
          recording_agent:  find_banking_agent,
          disbursing_agent: find_banking_agent
        )
        

        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_banking_agent.cash_account
        )

        voucher.voucher_amounts.debit.build(
          amount: amount,
          account: find_merchant_depository_account
        )

        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_banking_agent.depository_account_for(clearing_house: find_clearing_house)
        )
        voucher.voucher_amounts.credit.build(
          amount: amount,
          account: find_utility_bill.receivable_account
        )
        voucher.save!
      end 

      def find_utility_bill
        UtilityBill.find(utility_bill_id)
      end 

      def find_clearing_house
        AutomatedClearingHouse.first
      end 

      def find_merchant_depository_account
        merchant = find_utility_bill.merchant 

        merchant.depository_account_for(clearing_house: find_clearing_house)
      end 


      def find_banking_agent
        BankingAgent.find(banking_agent_id)
      end 
    end 
  end 
end 