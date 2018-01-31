module StoreFrontModule
  class UnitOfMeasurement < ApplicationRecord
    belongs_to :product

    def self.base_measurement
      where(base_measurement: true).order(created_at: :asc).last
    end
    def quantity_and_code
      "#{quantity} / #{code}"
    end

    def conversion_multiplier
      if base_measurement?
        quantity
      else
        conversion_quantity
      end
    end
  end
end
