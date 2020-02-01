FactoryBot.define do
  factory :level_four_account_category, class: AccountingModule::LevelFourAccountCategory do
    title { Faker::Company.bs }
    code { SecureRandom.uuid }
    association :office

    factory :asset_level_four_account_category, class: AccountingModule::AccountCategories::LevelFourAccountCategories::Asset do
      type { 'AccountingModule::AccountCategories::LevelFourAccountCategories::Asset' }
    end

    factory :liability_level_four_account_category, class: AccountingModule::AccountCategories::LevelFourAccountCategories::Liability do
      type { 'AccountingModule::AccountCategories::LevelFourAccountCategories::Liability' }
    end

    factory :equity_level_four_account_category, class: AccountingModule::AccountCategories::LevelFourAccountCategories::Equity do
      type { 'AccountingModule::AccountCategories::LevelFourAccountCategories::Equity' }
    end

    factory :revenue_level_four_account_category, class: AccountingModule::AccountCategories::LevelFourAccountCategories::Revenue do
      type { 'AccountingModule::AccountCategories::LevelFourAccountCategories::Revenue' }
    end

    factory :expense_level_four_account_category, class: AccountingModule::AccountCategories::LevelFourAccountCategories::Expense do
      type { 'AccountingModule::AccountCategories::LevelFourAccountCategories::Expense' }
    end
  end
end
