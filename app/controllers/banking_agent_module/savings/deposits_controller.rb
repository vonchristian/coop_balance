module BankingAgentModule 
  module Savings 
    class DepositsController < ApplicationController
      layout "banking_agent"
      skip_before_action :authenticate_user!, only: [:new, :create]

      def new 
        @saving = current_banking_agent.savings.find(params[:saving_id])
        @deposit = BankingAgentModule::Savings::Deposit.new 
      end 
      def create 
        @saving = current_banking_agent.savings.find(params[:saving_id])
        @deposit = BankingAgentModule::Savings::Deposit.new(deposit_params)
        if @deposit.valid?
          
          @deposit.process!
          voucher = current_banking_agent.vouchers.find_by!(account_number: params[:banking_agent_module_savings_deposit][:account_number])
          redirect_to banking_agent_module_saving_deposit_confirmation_url(id: voucher.id), notice: "Transaction created successfully."
        else 
          render :new, status: :unprocessable_entity
        end 
      end 

      private 
      def deposit_params
        params.require(:banking_agent_module_savings_deposit).
        permit(:amount, :reference_number, :description, :cart_id, :saving_id, :banking_agent_id, :account_number)
      end 
    end 
  end 
end 