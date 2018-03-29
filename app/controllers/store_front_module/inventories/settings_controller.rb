module StoreFrontModule
  module Inventories
    class SettingsController < ApplicationController
      def index
        @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes(:sales => [:unit_of_measurement, :sales_line_item]).find(params[:inventory_id])
      end
    end
  end
end
