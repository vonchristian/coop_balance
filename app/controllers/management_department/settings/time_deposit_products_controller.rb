module ManagementDepartment
  module Settings
    class TimeDepositProductsController < ApplicationController
      def new
        @time_deposit_product = TimeDepositProduct.new
      end
      def create
        @time_deposit_product = TimeDepositProduct.create(time_deposit_product_params)
        if @time_deposit_product.valid?
          @time_deposit_product.save
          redirect_to "/", notice: "Succeess"
        else
          render :new
        end
      end

      private
      def time_deposit_product_params
        params.require(:time_deposit_product).permit(:name, :interest_rate, :minimum_amount, :maximum_amount, :interest_recurrence)
      end
    end
  end
end
