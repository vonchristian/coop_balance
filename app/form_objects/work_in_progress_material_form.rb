class WorkInProgressMaterialForm
  include ActiveModel::Model
  attr_accessor :quantity, :date, :raw_material_id
  def save
    ActiveRecord::Base.transaction do
      create_work_in_progress_materials
    end
  end
  def find_raw_material
    RawMaterial.find_by(id: raw_material_id)
  end
  def create_work_in_progress_materials
   find_raw_material.work_in_progress_materials.create(quantity: quantity, date: date)
 end
end
