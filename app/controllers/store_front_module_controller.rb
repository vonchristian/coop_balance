class StoreFrontModuleController < ApplicationController
  def index
    if params[:search].present?
      @products = StoreFrontModule::Product.text_search(params[:search]).all
    else
      @products = StoreFrontModule::Product.all
    end
    @cart = current_cart
    @line_item = StoreFrontModule::LineItem.new
    @checkout = StoreFrontModule::CheckoutForm.new
  end
end
