module ManagementDepartment
  module Settings
    class ShareCapitalProductsController < ApplicationController
      def new
        @share_capital_product = ManagementDepartment::ShareCapitalProductForm.new
      end
      def create
        @share_capital_product = ManagementDepartment::ShareCapitalProductForm.new(share_capital_product_params)
        if @share_capital_product.valid?
          @share_capital_product.register
          redirect_to "/", notice: "Succeess"
        else
          render :new
        end
      end

      private
      def share_capital_product_params
        params.require(:management_department_share_capital_product_form).permit(:name, :cost_per_share, :share_count)
      end
    end
  end
end
