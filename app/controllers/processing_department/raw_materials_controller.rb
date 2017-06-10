module ProcessingDepartment
  class RawMaterialsController < ApplicationController
    def new
      @raw_material = RawMaterialForm.new
    end
    def create
      @raw_material = RawMaterialForm.new(raw_material_params)
      if @raw_material.valid?
        @raw_material.save
        redirect_to processing_department_root_url, notice: "Success"
      else
        render :new
      end
    end

    private
    def raw_material_params
      params.require(:raw_material_form).permit(:name, :description, :unit, :unit_cost, :total_cost, :quantity, :delivery_date, :supplier_id, :recorder_id, :has_freight, :freight_in, :discounted, :discount_amount)
    end
  end
end
