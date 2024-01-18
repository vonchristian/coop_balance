module ManagementModule
  module Configurations
    class LoanProtectionPlanProvidersController < ApplicationController
      respond_to :html, :json
      def new
        @loan_protection_plan_provider = current_cooperative.loan_protection_plan_providers.build
        respond_modal_with @loan_protection_plan_provider
        # authorize [:management_module, :settings, :loan_protection_plan_provider]
      end

      def create
        @loan_protection_plan_provider = current_cooperative.loan_protection_plan_providers.create(provider_params)
        # authorize [:management_module, :settings, :loan_protection_plan_provider]
        respond_modal_with @loan_protection_plan_provider, location: management_module_settings_url,
                                                           notice: 'Plan Provider saved successfully.'
      end

      private

      def provider_params
        params.require(:loans_module_loan_protection_plan_provider)
              .permit(:business_name, :rate, :accounts_payable_id)
      end
    end
  end
end
