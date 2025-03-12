require "will_paginate/array"
module StoreFrontModule
  class InventoriesController < ApplicationController
    def index
      @inventories = StoreFrontModule::LineItems::PurchaseLineItem.processed.sort_by(&:date).reverse.paginate(page: params[:page], per_page: 25)
    end

    def show
      @line_item = StoreFrontModule::LineItems::PurchaseLineItem.includes([ sales: [ :unit_of_measurement ] ]).find(params[:id])
    end
  end
end
