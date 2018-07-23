class AccountBudget < ApplicationRecord
  belongs_to :account, class_name: "AccountingModule::Account"
  validates :account_id, :year, :proposed_amount, presence: true
  validates :proposed_amount, numericality: true
  def self.current
    order(year: :desc).first
  end
end
