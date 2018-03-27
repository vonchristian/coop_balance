module StoreFrontModule
  module Inventories
    class PurchaseReturnsController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.find(params[:inventory_id])
        @purchase_returns = @line_item.purchase_return_line_items.processed.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
