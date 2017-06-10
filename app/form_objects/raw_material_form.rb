class RawMaterialForm
  include ActiveModel::Model
  attr_accessor :name, :description, :unit, :unit_cost, :total_cost, :quantity, :delivery_date, :supplier_id

  def save
    ActiveRecord::Base.transaction do
      create_raw_material
      create_raw_material_stocks
    end
  end
  def create_raw_material
    RawMaterial.create(name: name, description: description, unit: unit)
  end
  def find_raw_material
    RawMaterial.find_by(name: name, description: description, unit: unit)
  end
  def create_raw_material_stocks
    find_raw_material.raw_material_stocks.create(unit_cost: unit_cost, total_cost: total_cost, delivery_date: delivery_date, supplier_id: supplier_id, quantity: quantity)
  end
end
