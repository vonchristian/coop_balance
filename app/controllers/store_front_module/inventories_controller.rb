module StoreFrontModule
  class InventoriesController < ApplicationController
    def index
      @inventories = StoreFrontModule::LineItems::PurchaseLineItem.all.paginate(page: params[:page], per_page: 25)
    end
    def show
      @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes([:referenced_purchase_line_items => [:unit_of_measurement]]).find(params[:id])
    end
  end
end
