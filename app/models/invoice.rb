class Invoice < ApplicationRecord
  belongs_to :invoiceable, polymorphic: true
  validates :number, uniqueness: true

end
