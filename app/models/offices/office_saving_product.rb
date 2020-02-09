module Offices
  class OfficeSavingProduct < ApplicationRecord
    belongs_to :saving_product,                    class_name: 'CoopServicesModule::SavingProduct'
    belongs_to :liability_account_category,        class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :interest_expense_account_category, class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :office,                            class_name: 'Cooperatives::Office'
    belongs_to :closing_account_category,          class_name: 'AccountingModule::LevelOneAccountCategory'
    belongs_to :forwarding_account,                class_name: 'AccountingModule::Account'

    validates :saving_product_id, presence: true, uniqueness: { scope: :office_id }
    delegate :name, to: :saving_product, prefix: true 
  end
end
