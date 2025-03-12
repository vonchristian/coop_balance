module ManagementModule
  module Settings
    class GracePeriodsController < ApplicationController
      respond_to :html, :json

      def new
        @grace_period = CoopConfigurationsModule::GracePeriod.new
        respond_modal_with @grace_period
      end

      def create
        @grace_period = CoopConfigurationsModule::GracePeriod.new
        @grace_period.update(grace_period_params)
        respond_modal_with @grace_period,
                           location: management_module_settings_configurations_url
      end

      private

      def grace_period_params
        params.require(:coop_configurations_module_grace_period).permit(:number_of_days)
      end
    end
  end
end
