class StoreController < ApplicationController
  def index
    if params[:name].present?
      @stocks = StoreModule::ProductStock.search_by_name(params[:name]).all.to_a.sort_by(&:date)
    else
      @stocks = StoreModule::ProductStock.all
    end 
    @cart = current_cart
    @line_item = StoreModle::LineItem.new
    @order = StoreModule::Order.new
  end
end
