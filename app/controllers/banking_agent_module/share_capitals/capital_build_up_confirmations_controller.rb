module BankingAgentModule
  module ShareCapitals
    class CapitalBuildUpConfirmationsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:show, :create, :destroy]
      
      def show 
        @share_capital        = current_banking_agent.share_capitals.find(params[:share_capital_id])
        @voucher              = current_banking_agent.vouchers.find(params[:id])
        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new 
      end 

      def create 
        @share_capital  = current_banking_agent.share_capitals.find(params[:share_capital_id])
        @voucher = current_banking_agent.vouchers.find(params[:banking_agent_module_vouchers_token_validation][:voucher_id])

        @voucher_confirmation = BankingAgentModule::Vouchers::TokenValidation.new(token_params)

        if @voucher_confirmation.validate! == true 
        
           ::Vouchers::EntryProcessing.new(voucher: @voucher).process!
        
          redirect_to banking_agent_module_share_capital_url(@share_capital), notice: "confirmed successfully."
        else 
          redirect_to banking_agent_module_share_capital_capital_build_up_confirmation_url(share_capital_id: @share_capital.id, id: @voucher.id), alert: "Invalid confirmation code"
        end 
      end 



      def destroy 
        @share_capital = current_banking_agent.share_capitals.find(params[:share_capital_id])
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