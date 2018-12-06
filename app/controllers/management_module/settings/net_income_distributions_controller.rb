module ManagementModule
  module Settings
    class NetIncomeDistributionsController < ApplicationController
      respond_to :html, :json
      def new
        @cooperative = current_cooperative
        @net_income_distribution = current_cooperative.net_income_distributions.build
        respond_modal_with @net_income_distribution
      end
      def create
        @cooperative = current_cooperative
        @net_income_distribution = current_cooperative.net_income_distributions.create(distribution_params)
        respond_modal_with @net_income_distribution,
        location: management_module_settings_configurations_url
      end

      private
      def distribution_params
        params.require(:net_income_distribution).
        permit(:account_id, :rate, :description)
      end
    end
  end
end
