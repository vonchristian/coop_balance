module ManagementModule
  module Settings
    module LoanProducts
      class PenaltyConfigurationsController < ApplicationController
        respond_to :html, :json

        def new
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
          @penalty_config = @loan_product.penalty_configs.build
          respond_modal_with @penalty_config
        end

        def create
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
          @penalty_config = @loan_product.penalty_configs.create(penalty_config_params)
          respond_modal_with @penalty_config,
                             location: management_module_settings_cooperative_products_url,
                             notice: "Penalty Configuration saved successfully."
        end

        private

        def penalty_config_params
          params.require(:loans_module_loan_products_penalty_config)
                .permit(:rate, :penalty_revenue_account_id, :penalty_receivable_account_id)
        end
      end
    end
  end
end
