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
          redirect_to management_module_settings_url, notice: "Cooperative details updated successfully."
        else 
          render :edit 
        end 
      end 

      private 
      def cooperative_params
        params.require(:cooperative).permit(:name, :registration_number, :address, :contact_number, :logo)
      end 
    end 
  end 
end