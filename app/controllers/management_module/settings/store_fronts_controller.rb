module ManagementModule
  module Settings
    class StoreFrontsController < ApplicationController
      def new
        @cooperative = current_user.cooperative
        @store_front = @cooperative.store_fronts.build
      end
      def create
        @cooperative = current_user.cooperative
        @store_front = @cooperative.store_fronts.create(store_front_params)
        if @store_front.valid?
          redirect_to management_module_settings_url, notice: "Store Front created successfully."
        else
          render :new
        end
      end

      private
      def store_front_params
        params.require(:store_front).permit(:name, :address, :contact_number)
      end
    end
  end
end
