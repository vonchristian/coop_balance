class TimeDeposit < ApplicationRecord
  belongs_to :member
  belongs_to :time_deposit_product
  has_many :entries, class_name: "AccountingDepartment::Entry", as: :commercial_document

  delegate :name, to: :time_deposit_product, allow_nil: true, prefix: true
  def balance
    amount = []
    entries.time_deposit.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
end
