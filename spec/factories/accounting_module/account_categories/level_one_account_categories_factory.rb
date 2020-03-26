FactoryBot.define do
  factory :level_one_account_category, class: AccountingModule::LevelOneAccountCategory do
    title { Faker::Company.bs }
    code { SecureRandom.uuid }
    association :categorizeable, factory: :office 

    factory :asset_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Asset do
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Asset' }
    end

    factory :liability_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Liability do
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Liability' }
    end

    factory :equity_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Equity do
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Equity' }
    end

    factory :revenue_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue do
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Revenue' }
    end

    factory :expense_level_one_account_category, class: AccountingModule::AccountCategories::LevelOneAccountCategories::Expense do
      type { 'AccountingModule::AccountCategories::LevelOneAccountCategories::Expense' }
    end
  end
end
