module ManagementModule 
  module Settings 
    class BreakContractFeesController < ApplicationController 
      def new
        @time_deposit_product = CoopServicesModule::TimeDepositProduct.find(params[:time_deposit_product_id])
        @break_contract_fee = BreakContractFee.new 
      end 
      def create
        @break_contract_fee = BreakContractFee.create(break_contract_fee_params)
        if @break_contract_fee.save 
          redirect_to management_module_settings_time_deposit_product_url(@break_contract_fee.time_deposit_product), notice: "Break Contract Fee set successfully"
        else 
          render :new 
        end 
      end 

      private 
      def break_contract_fee_params
        params.require(:break_contract_fee).permit(:amount, :rate, :fee_type, :time_deposit_product_id)
      end 
    end 
  end 
end