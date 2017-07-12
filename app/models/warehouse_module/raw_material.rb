class RawMaterial < ApplicationRecord
  has_many :raw_material_stocks
  has_many :work_in_process_materials
  has_many :finished_good_materials
end
