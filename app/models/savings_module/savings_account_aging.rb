module SavingsModule
  class SavingsAccountAging < ApplicationRecord
    belongs_to :savings_account, class_name: 'MembershipsModule::Saving'
    belongs_to :savings_aging_group, class_name: 'SavingsModule::SavingsAgingGroup'
  end
end 