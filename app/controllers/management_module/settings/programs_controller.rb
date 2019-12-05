module ManagementModule
	module Settings
		class ProgramsController < ApplicationController
			respond_to :html, :json

      def index
        @programs = current_cooperative.programs
      end
			def new
				@program = Cooperatives::Program.new
			end

			def create
				@program = Cooperatives::Program.create(program_params)
        if @program.valid?
          @program.save!
          redirect_to management_module_settings_programs_url, notice: "Program created successfully."
        else
          render :new
        end
			end

			private

			def program_params
			  params.require(:cooperatives_program).permit(:name, :amount, :default_program, :description, :payment_schedule_type, :account_id, :cooperative_id, :level_one_account_category_id)
			end
		end
	end
end
