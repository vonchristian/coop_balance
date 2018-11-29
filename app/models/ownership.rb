class Ownership < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :ownable, polymorphic: true
end
