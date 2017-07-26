module ManagementDepartment
	module Settings 
		class ProgramsController < ApplicationController
			def new 
				@program = Program.new 
			end 
			def create 
				@program = Program.create(program_params)
				if @program.save 
					redirect_to management_department_settings_url, notice: "Program created successfully."
				else
				  render :new 
				end 
			end 

			private 

			def program_params
			  params.require(:program).permit(:name, :contribution, :default_program)
			end 
		end
	end 
end

