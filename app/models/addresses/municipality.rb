module Addresses
  class Municipality < ApplicationRecord
    belongs_to :province
    has_many :barangays
    has_many :streets

    validates :name, presence: true, uniqueness: { scope: :province_id }

  end
end
