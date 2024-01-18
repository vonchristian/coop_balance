class StockRegistryTemporaryProduct < ApplicationRecord
  belongs_to :store_front
  belongs_to :cooperative
  belongs_to :employee, class_name: 'User'
  belongs_to :stock_registry, class_name: 'Registries::StockRegistry'
  validates :date, presence: true
  def self.total_cost
    sum(:total_cost)
  end
end
