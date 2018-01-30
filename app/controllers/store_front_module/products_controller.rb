module StoreFrontModule
  class ProductsController < ApplicationController
    def index
      if params[:category_id].present?
        @products = StoreFrontModule::Category.find(params[:category_id]).products
      else
        @products = StoreFrontModule::Product.all
      end
      @categories = StoreFrontModule::Category.all
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
    def new
      @product = StoreFrontModule::Product.new
      authorize [:store_front_module, :product]
    end
    def create
      @product = StoreFrontModule::Product.create(product_params)
      if @product.valid?
        @product.save
        redirect_to store_front_module_products_url, notice: "created successfully"
      else
        render :new
      end
    end

    def show
      @product = StoreFrontModule::Product.find(params[:id])
      @stocks = @product.stocks.paginate(:page => params[:page], :per_page => 35)
    end

    private
    def product_params
      params.require(:store_front_module_product).permit(:name, :description, :unit)
    end
  end
end
