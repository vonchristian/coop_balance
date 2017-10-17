class Street < ApplicationRecord
  belongs_to :barangay
  belongs_to :municipality
end
