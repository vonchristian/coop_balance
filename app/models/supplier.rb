class Supplier < ApplicationRecord
  has_many :raw_material_stocks
  has_many :addresses, as: :addressable
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  def full_name
    [first_name, last_name].join(" ")
  end
  def balance
    deliveries - payments
  end
  def payments
    amount = []
    AccountingDepartment::Entry.supplier_payment.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
  def deliveries
    amount = []
    AccountingDepartment::Entry.supplier_delivery.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end

end
