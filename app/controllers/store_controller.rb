class StoreController < ApplicationController
  def index
    if params[:search].present?
      @stocks = StoreModule::ProductStock.text_search(params[:search]).all.to_a.sort_by(&:date)
    else
      @stocks = StoreModule::ProductStock.all.includes(:product).paginate(:page => params[:page], :per_page => 35)
    end
    @cart = current_cart
    @line_item = StoreModule::LineItem.new
    @checkout = StoreFrontModule::CheckoutForm.new
  end
end
