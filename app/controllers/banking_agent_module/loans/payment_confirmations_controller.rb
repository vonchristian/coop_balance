module BankingAgentModule
  module Loans
    class PaymentConfirmationsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:show, :create, :destroy]
      
      def show 
        @loan  = current_banking_agent.loans.find(params[:loan_id])
        @voucher = current_banking_agent.vouchers.find(params[:id])
        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new 
      end 

      def create 
        @loan  = current_banking_agent.loans.find(params[:loan_id])
        @voucher = current_banking_agent.vouchers.find(params[:banking_agent_module_vouchers_token_validation][:voucher_id])

        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new(token_params)

        if @voucher_confirmation.validate! == true 
        
           ::Vouchers::EntryProcessing.new(voucher: @voucher).process!
        
          redirect_to banking_agent_module_loan_url(@loan), notice: "confirmed successfully."
        else 
          redirect_to banking_agent_module_loan_payment_confirmation_url(loan_id: @loan.id, id: @voucher.id), alert: "Invalid"
        end 
      end 



      def destroy 
        @saving = current_banking_agent.savings.find(params[:saving_id])
        current_banking_agent_cart.destroy 
        redirect_to banking_agent_module_saving_url(@saving), alert: "cancelled successfully"
      end 
      def token_params
        params.require(:banking_agent_module_vouchers_token_validation).
        permit(:voucher_id, :token)
      end 
    end
  end 
end 