class UnitOfMeasurement < ApplicationRecord
  belongs_to :product
  def self.base_measurement
    where(base_measurement: true).order(created_at: :asc).last
  end
  def quantity_and_code
    "#{quantity} / #{code}"
  end

  def convert_quantity(quantity)
    if base_measurement?
      quantity.to_f
    else
      quantity.to_f * conversion_quantity
    end
  end
end
