module AccountingModule
  class AccountSubCategory < ApplicationRecord
    belongs_to :main_category, class_name: 'AccountingModule::AccountCategory', foreign_key: 'main_category_id'
    belongs_to :sub_category,  class_name: 'AccountingModule::AccountCategory', foreign_key: 'sub_category_id'
    validates :sub_category_id, uniqueness: { scope: :main_category_id }

    def self.main_categories
      ids = pluck(:main_category_id)
      AccountingModule::AccountCategory.where(id: ids)
    end

    def self.sub_categories
      ids = pluck(:sub_category_id)
      AccountingModule::AccountCategory.where(id: ids)
    end
  end
end
