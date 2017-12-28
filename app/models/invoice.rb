class Invoice < ApplicationRecord
  belongs_to :invoiceable, polymorphic: true
  validates :number, uniqueness: true

  def self.generate_number(invoiceable)
    return false if invoiceable.invoice.present?
    if self.exists?
      order(created_at: :asc).last.number.succ
    else
      "0"
    end
  end
end
