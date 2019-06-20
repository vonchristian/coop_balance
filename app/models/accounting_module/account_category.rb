module AccountingModule
  class AccountCategory < ApplicationRecord
    enum category_type: [:asset, :liability, :equity, :revenue, :expense]

    belongs_to :cooperative
    has_many :account_sub_categories, class_name: 'AccountingModule::AccountSubCategory', foreign_key: 'main_category_id'
    has_many :sub_categories,         class_name: 'AccountingModule::AccountCategory', through: :account_sub_categories, source: :sub_category
    has_many :accounts, class_name: 'AccountingModule::Account', dependent: :nullify
  end
end
