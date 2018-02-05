module StoreFrontModule
  module Orders
    class SalesOrdersController < ApplicationController
      def index
        @sales_orders = StoreFrontModule::Orders::SalesOrder.all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @sales_order = StoreFrontModule::Orders::SalesOrder.find(params[:id])
        @customer = @sales_order.commercial_document
      end
    end
  end
end
