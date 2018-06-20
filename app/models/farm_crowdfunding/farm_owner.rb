class FarmOwner < ApplicationRecord
  belongs_to :farm
  belongs_to :owner, polymorphic: true
end
