class StoreController < ApplicationController
  def index
    if params[:name].present?
      @stocks = ProductStock.search_by_name(params[:name]).all.to_a.sort_by(&:date)
    else
      @stocks = ProductStock.all
    end 
    @cart = current_cart
    @line_item = LineItem.new
    @order = Order.new
  end
end
