FactoryBot.define do
  factory :account, class: AccountingModule::Account do
    sequence(:name) { |n| "#{n}"}
    code            { Faker::Number.number(digits: 12) }

    factory :asset, class: 'AccountingModule::Asset' do
      association :level_one_account_category, factory: :asset_level_one_account_category
    end

    factory :liability, class: 'AccountingModule::Liability' do
      association :level_one_account_category, factory: :liability_level_one_account_category
    end

    factory :equity, class: 'AccountingModule::Equity' do
      association :level_one_account_category, factory: :equity_level_one_account_category
    end

    factory :revenue, class: 'AccountingModule::Revenue' do
      association :level_one_account_category, factory: :revenue_level_one_account_category
    end

    factory :expense, class: 'AccountingModule::Expense' do
      association :level_one_account_category, factory: :expense_level_one_account_category
    end
  end
end
