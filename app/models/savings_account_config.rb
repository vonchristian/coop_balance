class SavingsAccountConfig < ApplicationRecord
  validates :closing_account_fee, numericality: true
end
