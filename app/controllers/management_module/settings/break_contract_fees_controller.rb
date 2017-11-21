module ManagementModule
  module Settings
    class BreakContractFeesController < ApplicationController
      def new
        @break_contract_fee = CoopConfigurationsModule::BreakContractFee.new
      end
      def create
        @break_contract_fee = CoopConfigurationsModule::BreakContractFee.create(break_contract_fee_params)
        if @break_contract_fee.save
          redirect_to management_module_settings_url, notice: "Break Contract Fee saved successfully"
        else
          render :new
        end
      end

      private
      def break_contract_fee_params
        params.require(:coop_configurations_module_break_contract_fee).permit(:amount, :rate)
      end
    end
  end
end
