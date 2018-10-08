module ManagementModule
  module Settings
    module LoanProducts
      class InterestConfigurationsController < ApplicationController
        def new
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
          @interest_configuration = @loan_product.interest_configs.build
        end
        def create
          @loan_product = LoansModule::LoanProduct.find(params[:loan_product_id])
          @interest_configuration = @loan_product.interest_configs.create(interest_configuration_params)
          if @interest_configuration.valid?
            @interest_configuration.save
            redirect_to management_module_settings_cooperative_products_url, notice: "Interest Configuration saved successfully"
          else
            render :new
          end
        end

        private
        def interest_configuration_params
          params.require(:loans_module_loan_products_interest_config).
          permit(:rate,
                 :calculation_type,
                 :prededuction_type,
                 :prededucted_rate,
                 :interest_revenue_account_id,
                 :unearned_interest_income_account_id,
                 :interest_receivable_account_id,
                 :interest_rebate_account_id)

        end
      end
    end
  end
end
