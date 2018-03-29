module StoreFrontModule
  module Inventories
    class InternalUsesController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(:sales => [:unit_of_measurement, :sales_line_item]).find(params[:inventory_id])
        @internal_uses = @line_item.internal_uses.order(date: :desc).paginate(page: params[:page], per_page: 25)
      end
    end
  end
end
