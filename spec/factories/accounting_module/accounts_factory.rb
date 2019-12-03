FactoryBot.define do
  factory :account, class: AccountingModule::Account do
    sequence(:name) { |n| "#{n}"}
    code            { Faker::Number.number(digits: 12) }

    factory :asset, class: AccountingModule::Asset do
    end

    factory :liability, class: AccountingModule::Liability do
    end

    factory :equity, class: AccountingModule::Equity do
    end

    factory :expense, class: AccountingModule::Expense do
    end

    factory :revenue, class: AccountingModule::Revenue do
    end
  end
end
