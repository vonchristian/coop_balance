class ShareCapital < ApplicationRecord
  belongs_to :member
  belongs_to :share_capital_product
  has_many :capital_build_ups
  delegate :name, to: :share_capital_product, allow_nil: true
  delegate :cost_per_share, to: :share_capital_product, allow_nil: true
  def self.subscribed_shares
    all.sum(&:subscribed_shares)
  end
  def subscribed_shares
    capital_build_ups.total
  end
  def balance
    amount = []
    AccountingDepartment::Entry.where(commercial_document: self).each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
end
