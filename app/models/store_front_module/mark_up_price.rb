module StoreFrontModule
  class MarkUpPrice < ApplicationRecord
    belongs_to :unit_of_measurement, class_name: "StoreFrontModule::UnitOfMeasurement"

    before_save :set_default_date

    validates :price, presence: true, numericality: { greater_than: 0.01 }

    def self.current
      order(date: :desc).first
    end

    private

    def set_default_date
      self.date ||= Time.zone.now
    end
  end
end
