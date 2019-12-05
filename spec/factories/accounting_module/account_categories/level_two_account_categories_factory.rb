FactoryBot.define do
  factory :level_two_account_category, class: AccountingModule::LevelTwoAccountCategory do
    title { Faker::Company.bs }
    code { SecureRandom.uuid }
    association :office

    factory :asset_level_two_account_category, class: AccountingModule::AccountCategories::LevelTwoAccountCategories::Asset do
      type { 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Asset' }
    end

    factory :liability_level_two_account_category, class: AccountingModule::AccountCategories::LevelTwoAccountCategories::Liability do
      type { 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Liability' }
    end

    factory :equity_level_two_account_category, class: AccountingModule::AccountCategories::LevelTwoAccountCategories::Equity do
      type { 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Equity' }
    end

    factory :revenue_level_two_account_category, class: AccountingModule::AccountCategories::LevelTwoAccountCategories::Revenue do
      type { 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Revenue' }
    end

    factory :expense_level_two_account_category, class: AccountingModule::AccountCategories::LevelTwoAccountCategories::Expense do
      type { 'AccountingModule::AccountCategories::LevelTwoAccountCategories::Expense' }
    end
  end
end
