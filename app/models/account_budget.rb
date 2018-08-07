class AccountBudget < ApplicationRecord
  belongs_to :account, class_name: "AccountingModule::Account"
  validates :account_id, :year, :proposed_amount, presence: true
  validates :proposed_amount, numericality: true
  validates :year, uniqueness: { scope: :account_id }
  def self.current
    order(year: :desc).first
  end
  def self.current_proposed_amount
    if current
      current.proposed_amount
    else
      0
    end
  end
  def self.for(args={})
    where(year: args[:year]).last
  end
  def self.variance(args={})
  end
end
