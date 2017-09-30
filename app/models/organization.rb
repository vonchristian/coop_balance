class Organization < ApplicationRecord
  has_one :membership, as: :memberable
end
