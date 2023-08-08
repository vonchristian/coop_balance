module SavingsModule
  class SavingsAccountAging < ApplicationRecord
    belongs_to :savings_account,     class_name: 'DepositssModule::Saving'
    belongs_to :savings_aging_group, class_name: 'SavingsModule::SavingsAgingGroup'

    validates :date, presence: true

    def self.current
      order(date: :desc).first
    end
  end
end
