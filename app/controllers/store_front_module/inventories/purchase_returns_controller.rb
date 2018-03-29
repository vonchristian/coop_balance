module StoreFrontModule
  module Inventories
    class PurchaseReturnsController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(:sales => [:unit_of_measurement, :sales_line_item]).find(params[:inventory_id])
        @purchase_returns = @line_item.purchase_returns.processed.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
