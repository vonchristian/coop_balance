module ManagementModule
	module Settings
		class ProgramsController < ApplicationController
			respond_to :html, :json

			def new
				@program = CoopServicesModule::Program.new
				respond_modal_with @program
			end

			def create
				@program = CoopServicesModule::Program.create(program_params)
        CoopServicesModule::Program.delay.subscribe_members(@program)
				respond_modal_with @program, 
					location: management_module_settings_configurations_url, 
					notice: "Program created successfully."
			end

			private

			def program_params
			  params.require(:coop_services_module_program).permit(:name, :amount, :default_program, :description, :payment_schedule_type, :account_id, :cooperative_id)
			end
		end
	end
end

