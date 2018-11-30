module StoreFrontModule
  class SuppliersController < ApplicationController
    def index
      if params[:search].present?
        @suppliers = current_cooperative.suppliers.text_search(params[:search]).paginate(:page => params[:page], :per_page => 50)
      else
        @suppliers = current_cooperative.suppliers.paginate(:page => params[:page], :per_page => 50)
      end
    end
    def new
      @supplier = Supplier.new
    end
    def create
      @supplier = Supplier.create(supplier_params)
    end
    def show
      @supplier = Supplier.find(params[:id])

    end

    private
    def supplier_params
      params.require(:supplier).permit(:first_name, :last_name, :contact_number, :business_name, :address, :cooperative_id)
    end
  end
end
