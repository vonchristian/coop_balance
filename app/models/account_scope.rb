class AccountScope < ApplicationRecord
  belongs_to :scopeable, polymorphic: true
  belongs_to :account,   polymorphic: true

  validates :account_id, uniqueness: { scope: :scopeable_id } 
end
