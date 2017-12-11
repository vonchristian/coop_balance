module Addresses
  class Municipality < ApplicationRecord
    has_many :barangays
    has_many :streets
    belongs_to :province
  end
end
