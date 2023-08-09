module BankingAgentModule 
  module ShareCapitals 
    class CapitalBuildUpsController < ApplicationController
      layout "banking_agent"

      skip_before_action :authenticate_user!, only: [:new, :create]
      def new 
        @share_capital    = current_banking_agent.share_capitals.find(params[:share_capital_id])
        @capital_build_up = BankingAgentModule::ShareCapitals::CapitalBuildUp.new 
      end 

      def create 
        @share_capital    = current_banking_agent.share_capitals.find(params[:share_capital_id])
        @capital_build_up = BankingAgentModule::ShareCapitals::CapitalBuildUp.new(capital_build_up_params)
        if @capital_build_up.valid?
          @capital_build_up.process!
          voucher = current_banking_agent.vouchers.find_by!(account_number: params[:banking_agent_module_share_capitals_capital_build_up][:account_number])
          redirect_to banking_agent_module_share_capital_capital_build_up_confirmation_url(id: voucher.id), notice: "Transaction created successfully."
        else 
          render :new, status: :unprocessable_entity
        end 
      end 

      private 
      def capital_build_up_params
        params.require(:banking_agent_module_share_capitals_capital_build_up).
        permit(:amount, :reference_number, :description, :cart_id, :share_capital_id, :banking_agent_id, :account_number)
      end 
    end 
  end 
end 