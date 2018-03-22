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
        params.require(:store_front).
        permit(:name,
               :address,
               :contact_number,
               :accounts_receivable_account_id,
               :accounts_payable_account_id,
               :merchandise_inventory_account_id,
               :cost_of_goods_sold_account_id,
               :sales_account_id,
               :sales_return_account_id,
               :spoilage_account_id
               )
      end
    end
  end
end
