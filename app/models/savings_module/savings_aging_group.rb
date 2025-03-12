module SavingsModule
  class SavingsAgingGroup < ApplicationRecord
    belongs_to :office,               class_name: "Cooperatives::Office"
    has_many :savings_account_agings, class_name: "SavingsModule::SavingsAccountAging"
    has_many :savings_accounts,       through: :savings_account_agings, class_name: "DepositsModule::Saving"

    validates :title, :start_num, :end_num, presence: true
    validates :title, uniqueness: { scope: :office_id }

    def num_range
      start_num..end_num
    end
  end
end
