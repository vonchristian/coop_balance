module StoreModule
  class ProductsController < ApplicationController
    def index
      if params[:category_id].present?
        @products = StoreModule::Category.find(params[:category_id]).products
      else
        @products = StoreModule::Product.all
      end
      @categories = StoreModule::Category.all
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
    def new
      @product = StoreModule::Product.new
      authorize [:store_module, :product]
    end
    def create
      @product = StoreModule::Product.create(product_params)
      if @product.valid?
        @product.save
        redirect_to store_module_products_url, notice: "created successfully"
      else
        render :new
      end
    end

    def show
      @product = StoreModule::Product.find(params[:id])
      @stocks = @product.stocks.paginate(:page => params[:page], :per_page => 35)
    end

    private
    def product_params
      params.require(:store_module_product).permit(:name, :description, :unit)
    end
  end
end
