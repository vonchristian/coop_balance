class ProcessingDepartmentController < ApplicationController
  def index
    @raw_materials = RawMaterial.all 
  end
end
