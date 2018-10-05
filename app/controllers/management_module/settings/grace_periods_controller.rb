module ManagementModule
	module Settings 
		class GracePeriodsController < ApplicationController 
			def new 
				@grace_period = CoopConfigurationsModule::GracePeriod.new 
			end 
			def create 
				@grace_period = CoopConfigurationsModule::GracePeriod.new 
				@grace_period.update(grace_period_params)
				if @grace_period.valid?
					@grace_period.save 
					redirect_to management_module_settings_configurations_url, notice: "Grace period created successfully."
				else 
					render :new 
				end 
			end 

			private 
			def grace_period_params
				params.require(:coop_configurations_module_grace_period).permit(:number_of_days)
			end 
		end 
	end 
end 