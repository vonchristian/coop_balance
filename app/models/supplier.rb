class Supplier < ApplicationRecord
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
