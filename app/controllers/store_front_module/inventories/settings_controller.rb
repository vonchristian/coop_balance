module StoreFrontModule
  module Inventories
    class SettingsController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.find(params[:inventory_id])
      end
    end
  end
end
