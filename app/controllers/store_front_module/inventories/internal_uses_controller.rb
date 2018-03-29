module StoreFrontModule
  module Inventories
    class InternalUsesController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.find(params[:inventory_id])
        @internal_uses = @line_item.internal_use_line_items.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
