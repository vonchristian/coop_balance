module Cooperatives
  class ShareCapitalProduct < ApplicationRecord
    extend Metricable
    extend Totalable
    extend VarianceMonitoring

    enum balance_averaging_type: [:monthly]

    belongs_to :cooperative
    belongs_to :office,    class_name: "Cooperatives::Office"
    has_many :subscribers, class_name: "DepositsModule::ShareCapital"

    validates :name,
              :cost_per_share, presence: true
    validates :name, uniqueness: { scope: :cooperative_id }
    validates :cost_per_share, numericality: true

    def self.default_product
      where(default_product: true).last
    end


  end
end
