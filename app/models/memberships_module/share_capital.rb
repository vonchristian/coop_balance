class ShareCapital < ApplicationRecord
  include PgSearch 
  pg_search_scope :text_search, :against => [:account_number]
  belongs_to :member
  belongs_to :share_capital_product
  has_many :capital_build_ups
  delegate :name, to: :share_capital_product, allow_nil: true
  delegate :cost_per_share, to: :share_capital_product, allow_nil: true
  has_many :capital_build_ups, class_name: "AccountingDepartment::Entry", as: :commercial_document
  def self.subscribed_shares
    all.sum(&:subscribed_shares)
  end
  def subscribed_shares
    capital_build_ups.total
  end
  def balance
    amount = []
    capital_build_ups.capital_build_up.each do |a|
      amount << a.debit_amounts.sum(&:amount)
    end
    amount.sum
  end
end
