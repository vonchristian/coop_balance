module WarehouseDepartment
  class PurchasesController < ApplicationController
    def index
      @purchases = RawMaterialStock.includes([:raw_material, :supplier]).all
    end
    def new
      @purchase = PurchaseForm.new
    end
    def create
      @purchase = PurchaseForm.new(purchase_params)
      if @purchase.valid?
        @purchase.save
        redirect_to warehouse_department_root_url, notice: "Success"
      else
        render :new
      end
    end

    private
    def purchase_params
      params.require(:purchase_form).permit(:recorder_id, :delivery_date, :reference_number, :supplier_id, :quantity, :raw_material_id, :unit_cost, :total_cost, :has_freight, :freight_in, :discounted, :discount_amount)
    end
  end
end
