class WarehouseDepartmentController < ApplicationController
  def index
    @raw_materials = RawMaterial.includes([:raw_material_stocks, :work_in_process_materials, :finished_good_materials]).all
  end
end
