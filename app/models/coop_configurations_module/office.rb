module CoopConfigurationsModule
  class Office < ApplicationRecord
    belongs_to :cooperative
    validates :name, presence: true, uniqueness: true
    validates :contact_number, presence: true
    validates :address, presence: true
  end
end
