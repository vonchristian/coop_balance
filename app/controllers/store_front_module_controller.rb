class StoreFrontModuleController < ApplicationController
  def index
    if params[:search].present?
      @products = StoreFrontModule::Product.text_search(params[:search]).all
    end
    @cart = current_cart
    @line_item = StoreFrontModule::LineItems::SalesOrderLineItemProcessing.new
    @checkout = StoreFrontModule::CheckoutForm.new
  end
end
