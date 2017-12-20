module ManagementModule
  module Settings
    class OfficesController < ApplicationController
      def new
        @cooperative = Cooperative.find(params[:cooperative_id])
        @branch = @cooperative.offices.build
      end
      def create
        @cooperative = Cooperative.find(params[:cooperative_id])
        @branch = @cooperative.offices.create(office_params)
        if @branch.valid?
          @branch.save
          redirect_to management_module_settings_cooperative_url(@cooperative), notice: "Branch created successfully"
        else
          render :new
        end
      end

      private
      def office_params
        params.require(:coop_configurations_module_office).permit(:contact_number, :address, :name)
      end
    end
  end
end