class AccountBudget < ApplicationRecord
  belongs_to :cooperative
  belongs_to :account, class_name: "AccountingModule::Account"
  validates :account_id, :year, :proposed_amount, presence: true
  validates :proposed_amount, numericality: true
  validates :year, uniqueness: { scope: :account_id }

  def self.current
    order(year: :desc).first
  end

  def self.current_proposed_amount
    return 0 if self.blank?
    current.proposed_amount
  end
  def self.for(args={})
    where(year: args[:year]).last
  end
  def self.variance(args={})
    first_year = args[:first_year]
    second_year = args[:second_year]
    first_year.proposed_amount - second_year.proposed_amount
  end
end
