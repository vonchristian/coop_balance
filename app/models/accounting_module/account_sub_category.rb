module AccountingModule
  class AccountSubCategory < ApplicationRecord
    belongs_to :main_category, class_name: 'AccountingModule::AccountCategory'
    belongs_to :sub_category, class_name: 'AccountingModule::AccountCategory'
    has_many :accounts,           class_name: 'AccountingModule::Account'

  end
end
