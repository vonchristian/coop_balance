module StoreFrontModule
  class ProductsController < ApplicationController
    def index
      if params[:category_id].present?
        @products = StoreFrontModule::Category.find(params[:category_id]).products.paginate(page: params[:page], per_page: 50)
      elsif params[:search].present?
        @products = StoreFrontModule::Product.text_search(params[:search]).paginate(page: params[:page], per_page: 50)
      else
        @products = StoreFrontModule::Product.all.paginate(page: params[:page], per_page: 50)
      end
      @categories = StoreFrontModule::Category.all
      respond_to do |format|
        format.html
        format.xlsx
      end
    end
    def new
      @product = StoreFrontModule::ProductRegistration.new
      authorize [:store_front_module, :product]
    end
    def create
      @product = StoreFrontModule::ProductRegistration.new(product_params)
      if @product.valid?
        @product.register!
        redirect_to store_front_module_products_url, notice: "created successfully"
      else
        render :new
      end
    end

    def show
      @product = StoreFrontModule::Product.find(params[:id])
    end

    private
    def product_params
      params.require(:store_front_module_product_registration).permit(
                  :category_id,
                  :name,
                  :description,
                  :unit_of_measurement_code,
                  :unit_of_measurement_description,
                  :quantity,
                  :price)
    end
  end
end
