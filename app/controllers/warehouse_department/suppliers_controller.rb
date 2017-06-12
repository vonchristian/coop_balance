module WarehouseDepartment
  class SuppliersController < ApplicationController
    def index
      @suppliers = Supplier.includes([:raw_material_stocks]).all
    end
    def new
      @supplier = Supplier.new
    end
    def create
      @supplier = Supplier.create(supplier_params)
      if @supplier.valid?
        @supplier.save
        redirect_to warehouse_department_suppliers_url, notice: "Supplier saved successfully."
      else
        render :new
      end
    end

    def show
      @supplier = Supplier.find(params[:id])
    end

    private
    def supplier_params
      params.require(:supplier).permit(:first_name, :last_name, :avatar)
    end
  end
end
