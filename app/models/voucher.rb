class Voucher < ApplicationRecord
  belongs_to :voucherable, polymorphic: true
  belongs_to :payee, polymorphic: true
  def self.generate_number
  	if self.last.present?
      "#{self.last.number.succ.rjust(12, '0')}"
    else 
      "#{1.to_s.rjust(12, '0')}"
    end
  end
end
