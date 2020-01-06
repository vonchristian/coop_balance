module Addresses
  class Municipality < ApplicationRecord
    belongs_to :province
    has_many :barangays
    has_many :streets

    validates :name, presence: true, uniqueness: { scope: :province_id }
    
    delegate :name, to: :province, prefix: true
    
    def name_and_province
      "#{name}, #{province_name}"
    end 
  end
end
