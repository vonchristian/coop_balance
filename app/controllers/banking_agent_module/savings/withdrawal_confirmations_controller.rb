module BankingAgentModule
  module Savings 
    class WithdrawalConfirmationsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:show, :create, :destroy]
      
      def show 
        @saving  = current_banking_agent.savings.find(params[:saving_id])
        @voucher = current_banking_agent.vouchers.find(params[:id])
      end 

      def create 
        @saving  = current_banking_agent.savings.find(params[:saving_id])
        @voucher = current_banking_agent.vouchers.find(params[:id])

         ::Vouchers::EntryProcessing.new(voucher: @voucher).process!
        
        redirect_to banking_agent_module_saving_url(@saving), notice: "Withdraw transaction confirmed successfully."
      end 



      def destroy 
        @saving = current_banking_agent.savings.find(params[:saving_id])
        current_banking_agent_cart.destroy 
        redirect_to banking_agent_module_saving_url(@saving), alert: "cancelled successfully"
      end 
    end
  end 
end 