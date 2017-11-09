module CoopConfigurationsModule
  class SavingsAccountConfig < ApplicationRecord
    validates :closing_account_fee, numericality: true, presence: true
  end
end
