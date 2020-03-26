module BankingAgentModule 
  module UtilityBills 
    class PaymentsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:new, :create]

      def new 
        @utility_bill = UtilityBill.find(params[:utility_bill_id])
        @payment = BankingAgentModule::UtilityBills::Payment.new 
      end 

      def create 
        @utility_bill = UtilityBill.find(params[:utility_bill_id])
        @payment      = BankingAgentModule::UtilityBills::Payment.new(payment_params)
        if @payment.valid?
          
          @payment.process!
          voucher = current_banking_agent.vouchers.find_by!(account_number: params[:banking_agent_module_utility_bills_payment][:account_number])
          redirect_to banking_agent_module_utility_bill_payment_confirmation_url(id: voucher.id), notice: "Transaction created successfully."
        else 
          render :new 
        end 
      end 

      private 
      def payment_params
        params.require(:banking_agent_module_utility_bills_payment).
        permit(:amount, :reference_number, :description, :cart_id, :utility_bill_id, :banking_agent_id, :account_number)
      end 
    end 
  end 
end 