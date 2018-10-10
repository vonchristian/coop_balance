class Ownership < ApplicationRecord
  belongs_to :owner
  belongs_to :ownable, polymorphic: true
end
