module ManagementDepartment
  module Settings
    class SavingProductsController < ApplicationController
      def new
        @saving_product = SavingProduct.new
      end
      def create
        @saving_product = SavingProduct.create(saving_product_params)
        if @saving_product.valid?
          @saving_product.save
          redirect_to "/", notice: "Succeess"
        else
          render :new
        end
      end

      private
      def saving_product_params
        params.require(:saving_product).permit(:name, :interest_rate, :interest_recurrence)
      end
    end
  end
end
