module StoreFrontModule
  module Orders
    class PurchaseReturnOrdersController < ApplicationController
      def index
        @purchase_return_orders = StoreFrontModule::Orders::PurchaseReturnOrder.all
      end
    end
  end
end