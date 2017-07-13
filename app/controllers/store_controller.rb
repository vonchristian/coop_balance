class StoreController < ApplicationController
  def index
    if params[:name].present?
      @stocks = StoreModule::ProductStock.search_by_name(params[:name]).all.to_a.sort_by(&:date)
    else
      @stocks = StoreModule::ProductStock.all.includes(:product)
    end 
    @cart = current_cart
    @line_item = StoreModule::LineItem.new
    @order = StoreModule::Order.new
  end
end
