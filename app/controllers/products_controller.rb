class ProductsController < ApplicationController
  def new 
    @product = StoreModule::Product.new 
  end 
  def create 
    @product = StoreModule::Product.create(product_params)
  end 

  private 
  def product_params
    params.require(:store_module_product).permit(:name)
  end 
end 