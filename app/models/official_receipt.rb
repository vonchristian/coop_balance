class OfficialReceipt < ApplicationRecord
  belongs_to :order
  def self.generate_number_for(order)
    return false if order.official_receipt.present?
    if all.blank?
      order.create_official_receipt(number: 1.to_s.rjust(12, "0"))
    else
      order.create_official_receipt(number: all.last.number.succ.rjust(12, "0"))
    end
  end
end
