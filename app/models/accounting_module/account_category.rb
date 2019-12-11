module AccountingModule
  class AccountCategory < ApplicationRecord
    has_many :account_sub_categories, dependent: :nullify
  end
end
