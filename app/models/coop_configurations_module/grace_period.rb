module CoopConfigurationsModule  
  class GracePeriod < ApplicationRecord
  	validates :number_of_days, presence: true, numericality: { greater_than_or_equal_to: 1 }
  end
end