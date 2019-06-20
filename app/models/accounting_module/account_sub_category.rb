module AccountingModule
  class AccountSubCategory < ApplicationRecord

    belongs_to :main_category, class_name: 'AccountingModule::AccountCategory', foreign_key: 'main_category_id'
    belongs_to :sub_category, class_name: 'AccountingModule::AccountCategory', foreign_key: 'sub_category_id'
    has_many :accounts,           class_name: 'AccountingModule::Account'

  end
end
