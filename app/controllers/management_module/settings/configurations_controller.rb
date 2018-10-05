module ManagementModule
	module Settings
		class ConfigurationsController < ApplicationController

			def index
				@cooperative = current_user.cooperative
      	@programs = CoopServicesModule::Program.all
      	@savings_account_config = CoopConfigurationsModule::SavingsAccountConfig.last
      	@cooperative_services = CoopServicesModule::CooperativeService.all
      	@store_fronts = StoreFront.all
      	@grace_period = CoopConfigurationsModule::GracePeriod.last
			end
		end
	end
end
