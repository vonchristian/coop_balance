module Addresses
  class Municipality < ApplicationRecord
    has_many :barangays
    has_many :streets
    belongs_to :province
    validates :name, presence: true, uniqueness: { scope: :province_id }

  end
end
