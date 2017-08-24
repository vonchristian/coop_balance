class DocumentaryStampTax < ApplicationRecord
  belongs_to :taxable, polymorphic: true
  def self.set(taxable)
  	(taxable.taxable_amount / 5_000) - 1 * 10 + 20
  end
end
