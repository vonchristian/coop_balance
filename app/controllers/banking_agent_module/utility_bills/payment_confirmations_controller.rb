module BankingAgentModule
  module UtilityBills
    class PaymentConfirmationsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:show, :create, :destroy]
      
      def show 
        @utility_bill  = UtilityBill.find(params[:utility_bill_id])
        @voucher = current_banking_agent.vouchers.find(params[:id])
        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new 
      end 

      def create 
        @utility_bill  = UtilityBill.find(params[:utility_bill_id])
        @voucher = current_banking_agent.vouchers.find(params[:banking_agent_module_vouchers_token_validation][:voucher_id])

        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new(token_params)

        if @voucher_confirmation.validate! == true 
        
           ::Vouchers::EntryProcessing.new(voucher: @voucher).process!
        
          redirect_to banking_agent_module_utility_bill_url(@utility_bill), notice: "confirmed successfully."
        else 
          redirect_to banking_agent_module_utility_bill_payment_confirmation_url(utility_bill_id: @utility_bill.id, id: @voucher.id), alert: "Invalid"
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