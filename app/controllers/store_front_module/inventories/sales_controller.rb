module StoreFrontModule
  module Inventories
    class SalesController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(:referenced_purchase_line_items => [:unit_of_measurement, :sales_line_item]).find(params[:inventory_id])
        @sales = @line_item.referenced_purchase_line_items.order(created_at: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
