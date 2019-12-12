FactoryBot.define do
  factory :office_saving_product, class: Offices::OfficeSavingProduct do
    association :liability_account_category, factory: :liability_level_one_account_category
    association :interest_expense_account_category, factory: :expense_level_one_account_category
    association :office
    association :closing_account_category, factory: :revenue_level_one_account_category
    association :forwarding_account, factory: :liability
    association :saving_product
  end
end
