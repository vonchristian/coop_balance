module ManagementModule
  module Settings
    class TimeDepositProductsController < ApplicationController
      respond_to :html, :json

      def new
        @time_deposit_product = current_cooperative.time_deposit_products.build
        respond_modal_with @time_deposit_product
      end

      def create
        @time_deposit_product = current_cooperative.time_deposit_products.create(time_deposit_product_params)
        respond_modal_with @time_deposit_product,
                           location: management_module_settings_cooperative_products_url,
                           notice: 'Time Deposit product saved successfully.'
      end

      def show
        @time_deposit_product = CoopServicesModule::TimeDepositProduct.find(params[:id])
      end

      private

      def time_deposit_product_params
        params.require(:coop_services_module_time_deposit_product)
              .permit(:name,
                      :interest_rate,
                      :minimum_deposit,
                      :maximum_deposit,
                      :number_of_days,
                      :break_contract_fee,
                      :break_contract_rate,
                      :account_id,
                      :interest_expense_account_id,
                      :break_contract_account_id,
                      :cooperative_id)
      end
    end
  end
end
