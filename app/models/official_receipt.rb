class OfficialReceipt < ApplicationRecord
  belongs_to :receiptable, polymorphic: true
  def self.generate_receipt
    if all.blank?
      self.create(number: "1".rjust(15, "0"))
    else
      self.create(number: all.order(created_at: :asc).last.number.succ.rjust(15, "0"))
    end
  end
end
