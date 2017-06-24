class Saving < ApplicationRecord
  include PgSearch
    pg_search_scope :text_search, :against => [:account_number]

  belongs_to :member
  belongs_to :saving_product
  delegate :name, to: :saving_product
  has_many :entries, class_name: "AccountingDepartment::Entry", as: :commercial_document
  
  def self.post_interests_earned
    all.each do |saving|
      InterestPosting.new.post_interests_earned(saving)
    end 
  end
  def balance
    deposits + interests_earned - withdrawals
  end
  def deposits
    entries.deposit.map{|a| a.debit_amounts.sum(:amount)}.sum
  end
  def withdrawals
    entries.withdrawal.map{|a| a.debit_amounts.sum(:amount)}.sum
  end
  def interests_earned
    entries.savings_interest.map{|a| a.debit_amounts.sum(:amount)}.sum
  end
  def can_withdraw?
    balance > 0
  end
end
