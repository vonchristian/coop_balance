module StoreFrontModule
  class UnitOfMeasurement < ApplicationRecord
    belongs_to :product
    has_many :mark_up_prices, class_name: "StoreFrontModule::MarkUpPrice",
                              dependent: :destroy
    validates :code, :base_quantity, presence: true
    delegate :price, to: :current_mark_up_price

    def self.base_measurement
      where(base_measurement: true)
    end

    def self.recent
      order(created_at: :desc).first
    end

    def current_mark_up_price
      mark_up_prices.current
    end

    def base_quantity_and_code
      "#{base_quantity} / #{code}"
    end


    def base_selling_price
      if base_measurement?
        price
      else
        price / conversion_multiplier
      end
    end

    def conversion_multiplier
      if base_measurement?
        base_quantity
      else
        conversion_quantity
      end
    end
  end
end
