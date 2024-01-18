module ManagementModule
  module Settings
    class CooperativesController < ApplicationController
      respond_to :html, :json

      def edit
        @cooperative = Cooperative.find(params[:id])
        respond_modal_with @cooperative
        authorize [:management_module, :settings, @cooperative]
      end

      def update
        @cooperative = Cooperative.find(params[:id])
        authorize [:management_module, :settings, @cooperative]
        @cooperative.update(cooperative_params)
        respond_modal_with @cooperative,
                           location: management_module_settings_url,
                           notice: 'Cooperative details saved successfully.'
      end

      def show
        @cooperative = Cooperative.find(params[:id])
        @offices = @cooperative.offices.all.paginate(page: params[:page], per_page: 15)
      end

      private

      def cooperative_params
        params.require(:cooperative).permit(:name, :registration_number, :address, :contact_number, operating_days: [])
      end

      def current_cooperative
        cooperative = current_user.cooperative
        session[:cooperative_id] = cooperative.id
        cooperative
      end
    end
  end
end
