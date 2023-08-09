module BankingAgentModule 
  module Loans 
    class PaymentsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:new, :create]

      def new 
        @loan = current_banking_agent.loans.find(params[:loan_id])
        @payment = BankingAgentModule::Loans::Payment.new 
      end 
      def create 
        @loan = current_banking_agent.loans.find(params[:loan_id])
        @payment = BankingAgentModule::Loans::Payment.new(payment_params)
        if @payment.valid?
          
          @payment.process!
          voucher = current_banking_agent.vouchers.find_by!(account_number: params[:banking_agent_module_loans_payment][:account_number])
          redirect_to banking_agent_module_loan_payment_confirmation_url(id: voucher.id), notice: "Transaction created successfully."
        else 
          render :new, status: :unprocessable_entity
        end 
      end 

      private 
      def payment_params
        params.require(:banking_agent_module_loans_payment).
        permit(:principal_amount, :interest_amount, :penalty_amount, :reference_number, :description, :cart_id, :loan_id, :banking_agent_id, :account_number)
      end 
    end 
  end 
end 