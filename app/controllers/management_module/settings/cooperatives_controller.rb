module ManagementModule
  module Settings
    class CooperativesController < ApplicationController
      def edit
        @cooperative = Cooperative.find(params[:id])
        authorize [:management_module, :settings, @cooperative]
      end
      def update
        @cooperative = Cooperative.find(params[:id])
        authorize [:management_module, :settings, @cooperative]
        @cooperative.update(cooperative_params)
        if @cooperative.save
          redirect_to management_module_settings_url, notice: "Cooperative details saved successfully."
        else
          render :edit
        end
      end
      def show
        @cooperative = Cooperative.find(params[:id])
      end

      private
      def cooperative_params
        params.require(:cooperative).permit(:name, :registration_number, :address, :contact_number, :logo)
      end
      def current_cooperative
    cooperative = current_user.cooperative
    session[:cooperative_id] = cooperative.id
    cooperative
  end
    end
  end
end
