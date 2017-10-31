module ManagementModule
  module Settings
    class TimeDepositProductsController < ApplicationController
      def new
        @time_deposit_product = CoopServicesModule::TimeDepositProduct.new
      end

      def create
        @time_deposit_product = CoopServicesModule::TimeDepositProduct.create(time_deposit_product_params)
        if @time_deposit_product.valid?
          @time_deposit_product.save
          redirect_to management_module_settings_url, notice: "Succeess"
        else
          render :new
        end
      end
      def show
        @time_deposit_product = CoopServicesModule::TimeDepositProduct.find(params[:id])
      end

      private
      def time_deposit_product_params
        params.require(:coop_services_module_time_deposit_product).permit(:name, :interest_rate, :minimum_amount, :maximum_amount, :time_deposit_product_type, :number_of_days, :account_id)
      end
    end
  end
end
