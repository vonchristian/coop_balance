module StoreFrontModule
  module Orders
    class PurchaseOrdersController < ApplicationController
      def index
        @purchase_orders = StoreFrontModule::Orders::PurchaseOrder.all.paginate(page: params[:page], per_page: 30)
      end
      def show
        @purchase_order = StoreFrontModule::Orders::PurchaseOrder.find(params[:id])
        @supplier = @purchase_order.commercial_document
      end
    end
  end
end
