module WarehouseDepartment
  class FinishedGoodsController < ApplicationController
    def index
      @finished_goods = FinishedGoodMaterial.all
    end
    def new
      @finished_good = FinishedGoodForm.new
    end
    def create
      @finished_good = FinishedGoodForm.new(finished_good_params)
      if @finished_good.valid?
        @finished_good.save
        redirect_to warehouse_department_root_url, notice: "Success"
      else
        render :new
      end
    end

    private
    def finished_good_params
      params.require(:finished_good_form).permit(:unit_cost, :total_cost, :quantity, :recorder_id, :raw_material_id)
    end
  end
end
