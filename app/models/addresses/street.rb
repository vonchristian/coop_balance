module Addresses
  class Street < ApplicationRecord
    belongs_to :barangay
    belongs_to :municipality
    validates :name, presence: true, uniqueness: { scope: :barangay_id }
  end
end
