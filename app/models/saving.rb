class Saving < ApplicationRecord
  belongs_to :member
  belongs_to :saving_product
  delegate :name, to: :saving_product

  def balance
    deposits - withdrawals
  end
  def deposits
    amount = []
    AccountingDepartment::Entry.deposit.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
  def withdrawals
    amount = []
    AccountingDepartment::Entry.withdrawal.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
end
