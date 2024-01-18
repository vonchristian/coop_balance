module StoreFrontModule
  module Inventories
    class SalesController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(sales: %i[unit_of_measurement sales_line_item]).find(params[:inventory_id])
        @sales = @line_item.sales.order(created_at: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
