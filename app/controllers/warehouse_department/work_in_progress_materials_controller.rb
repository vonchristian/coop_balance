module WarehouseDepartment
  class WorkInProgressMaterialsController < ApplicationController
    def new
      @raw_material = RawMaterial.find(params[:raw_material_id])
      @work_in_progress_material = WorkInProgressMaterialForm.new
    end
    def create
      @raw_material = RawMaterial.find(params[:raw_material_id])
      @work_in_progress_material = WorkInProgressMaterialForm.new(work_in_progress_material_params)
      if @work_in_progress_material.valid?
        @work_in_progress_material.save
        redirect_to warehouse_department_root_url, notice: "Success"
      else
        render :new
      end
    end

    private
    def work_in_progress_material_params
      params.require(:work_in_progress_material_form).permit(:quantity, :date, :raw_material_id)
    end
  end
end
