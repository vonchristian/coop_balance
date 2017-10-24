class Organization < ApplicationRecord
  has_one :membership, as: :memberable
  has_many :members
end
