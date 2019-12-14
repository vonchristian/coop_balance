module Offices
  class OfficeTimeDepositProduct < ApplicationRecord
    belongs_to :office,                            class_name: 'Cooperatives::Office'
    belongs_to :liability_account_category,        class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :interest_expense_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :break_contract_account_category,   class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :time_deposit_product,              class_name: 'CoopServicesModule::TimeDepositProduct'
    belongs_to :forwarding_account,                class_name: 'AccountingModule::Account'

    validates :time_deposit_product_id, presence: true, uniqueness: { scope: :office_id }
  end
end
