class ProductsController < ApplicationController
  def index
    @products = StoreModule::Product.all
  end
  def new
    @product = StoreModule::Product.new
  end
  def create
    @product = StoreModule::Product.create(product_params)
    if @product.valid?
      @product.save
      redirect_to products_url, notice: "created successfully"
    else
      render :new
    end
  end

  def show
    @product = StoreModule::Product.find(params[:id])
  end

  private
  def product_params
    params.require(:store_module_product).permit(:name, :description, :unit)
  end
end
