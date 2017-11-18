module ManagementModule
  module Settings
    class BranchesController < ApplicationController
      def new
        @cooperative = Cooperative.find(params[:cooperative_id])
        @branch = @cooperative.branch_offices.build
      end
      def create
        @cooperative = Cooperative.find(params[:cooperative_id])
        @branch = @cooperative.branch_offices.create(branch_params)
        if @branch.valid?
          @branch.save
          redirect_to management_module_settings_cooperative_url(@cooperative), notice: "Branch created successfully"
        else
          render :new
        end
      end

      private
      def branch_params
        params.require(:coop_configurations_module_branch_office).permit(:contact_number, :address, :branch_name)
      end
    end
  end
end
