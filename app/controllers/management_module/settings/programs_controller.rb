module ManagementModule
	module Settings
		class ProgramsController < ApplicationController
			respond_to :html, :json

			def new
				@program = Cooperatives::Program.new
				respond_modal_with @program
			end

			def create
				@program = Cooperatives::Program.create(program_params)
				respond_modal_with @program,
					location: management_module_settings_configurations_url,
					notice: "Program created successfully."
			end

			private

			def program_params
			  params.require(:cooperatives_program).permit(:name, :amount, :default_program, :description, :payment_schedule_type, :account_id, :cooperative_id)
			end
		end
	end
end
