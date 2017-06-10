module ProcessingDepartment
  class FinishedGoodsMaterialsController < ApplicationController
    def new
      @raw_material = RawMaterial.find(params[:raw_material_id])
      @finished_goods_material = FinishedGoodsMaterialForm.new
    end
    def create
      @raw_material = RawMaterial.find(params[:raw_material_id])
      @finished_goods_material = FinishedGoodsMaterialForm.new(finished_goods_material_params)
      if @finished_goods_material.valid?
        @finished_goods_material.save
        redirect_to processing_department_root_url, notice: "Success"
      else
        render :new
      end
    end

    private
    def finished_goods_material_params
      params.require(:finished_goods_material_form).permit(:quantity, :date, :raw_material_id)
    end
  end
end
