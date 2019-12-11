FactoryBot.define do
  factory :level_three_account_category, class: AccountingModule::LevelThreeAccountCategory do
    title { Faker::Company.bs }
    code  { SecureRandom.uuid }
    association :office

    factory :asset_level_three_account_category, class: AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset do
      type { 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Asset' }
    end

    factory :liability_level_three_account_category, class: AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability do
      type { 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability' }
    end

    factory :equity_level_three_account_category, class: AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity do
      type { 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Equity' }
    end

    factory :revenue_level_three_account_category, class: AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue do
      type { 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Revenue' }
    end

    factory :expense_level_three_account_category, class: AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense do
      type { 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Expense' }
    end
  end
end
