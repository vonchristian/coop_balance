module ManagementModule
	module Settings
		class ProgramsController < ApplicationController
			def new
				@program = CoopServicesModule::Program.new
			end
			def create
				@program = CoopServicesModule::Program.create(program_params)
				if @program.save
           CoopServicesModule::Program.delay.subscribe_members(@program)
					redirect_to management_module_settings_url, notice: "Program created successfully."
				else
				  render :new
				end
			end

			private

			def program_params
			  params.require(:coop_services_module_program).permit(:name, :contribution, :default_program, :description, :payment_schedule_type, :account_id)
			end
		end
	end
end

