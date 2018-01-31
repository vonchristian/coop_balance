class StoreFrontModuleController < ApplicationController
  def index
    if params[:search].present?
      @stocks = StoreFrontModule::ProductStock.text_search(params[:search]).all.to_a.sort_by(&:date).reverse
    else
      @stocks = StoreFrontModule::ProductStock.all
    end
    @cart = current_cart
    @line_item = StoreFrontModule::LineItem.new
    @checkout = StoreFrontModule::CheckoutForm.new
  end
end
