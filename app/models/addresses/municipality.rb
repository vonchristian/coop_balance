module Addresses
  class Municipality < ApplicationRecord
    has_many :barangays
    has_many :streets
  end
end 