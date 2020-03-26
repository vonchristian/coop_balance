module BankingAgentModule
  module Loans
    class Payment

      include ActiveModel::Model

      attr_accessor :principal_amount, :interest_amount, :penalty_amount, :reference_number, :description, :loan_id, :banking_agent_id, :cart_id, :account_number

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
          payee:            find_loan.borrower, 
          recording_agent:  find_banking_agent,
          disbursing_agent: find_banking_agent
        )
        

        voucher.voucher_amounts.debit.build(
          amount: total_amount,
          account: find_banking_agent.cash_account
        )

        voucher.voucher_amounts.debit.build(
          amount: total_amount,
          account: find_office_depository_account
        )

        voucher.voucher_amounts.credit.build(
          amount: total_amount,
          account: find_banking_agent.depository_account_for(clearing_house: find_clearing_house)
        )
        if principal_amount.to_f > 0 
          voucher.voucher_amounts.credit.build(
            amount: principal_amount,
            account: find_loan.receivable_account
          )
        end
        
        if interest_amount.to_f > 0 
          voucher.voucher_amounts.credit.build(
            amount: interest_amount,
            account: find_loan.interest_revenue_account
          )
        end

        if penalty_amount.to_f > 0 
          voucher.voucher_amounts.credit.build(
            amount: penalty_amount,
            account: find_loan.interest_revenue_account
          )
        end
        voucher.save!
      end 
      def total_amount
        principal_amount.to_f + 
        interest_amount.to_f + 
        penalty_amount.to_f 
      end 

      def find_loan 
        find_banking_agent.loans.find(loan_id)
      end 

      def find_clearing_house
        AutomatedClearingHouse.first
      end 

      def find_office_depository_account
        office = find_loan.office 

        office.depository_account_for(clearing_house: find_clearing_house)
      end 

      def find_banking_agent
        BankingAgent.find(banking_agent_id)
      end 
    end 
  end 
end 