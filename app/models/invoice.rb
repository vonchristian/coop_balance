class Invoice < ApplicationRecord
  belongs_to :invoicable, polymorphic: true
end
