module AccountingModule
  class AccountSubCategory < ApplicationRecord
    belongs_to :main_category,  class_name: 'AccountingModule::AccountCategory'
    belongs_to :sub_category,   class_name: 'AccountingModule::AccountCategory'

    validates :sub_category_id, uniqueness: { scope: :main_category_id }
    validate :same_origin?
    validate :same_type?

    def self.main_category_ids
      pluck(:main_category_id)
    end

    def self.sub_category_ids
      pluck(:sub_category_id)
    end

    private

    def same_origin?
      errors.add(:sub_category_id, 'Not the same origin') if main_category.cooperative != sub_category.cooperative
    end

    def same_type?
      errors.add(:sub_category_id, 'Not the same type') if main_category.type != sub_category.type
    end
  end
end
