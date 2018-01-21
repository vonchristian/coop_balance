class OfficialReceipt < ApplicationRecord
  belongs_to :receiptable, polymorphic: true
  def self.create_receipt(receiptable)
    return false if receiptable.official_receipt.present?
    if all.blank?
      receiptable.create_official_receipt(number: 1.to_s.rjust(12, "0"))
    else
      receiptable.create_official_receipt(number: all.order(created_at: :asc).last.number.succ.rjust(12, "0"))
    end
  end
end
