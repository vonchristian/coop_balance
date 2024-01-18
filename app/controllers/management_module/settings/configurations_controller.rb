module ManagementModule
  module Settings
    class ConfigurationsController < ApplicationController
      def index
        @cooperative = current_user.cooperative
        @programs                       = current_cooperative.programs
        @cooperative_services           = current_cooperative.cooperative_services
        @store_fronts                   = current_cooperative.store_fronts
        @grace_period                   = CoopConfigurationsModule::GracePeriod.last
        @loan_protection_plan_providers = current_cooperative.loan_protection_plan_providers
        @net_income_distributions       = current_cooperative.net_income_distributions
      end
    end
  end
end
