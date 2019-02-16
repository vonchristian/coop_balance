Factory.define do
  factory :account, class: AccountingModule::Account do
    sequence(:name) { |n| "#{n}"}
    code            { Faker::Number.number(12) }

    factory :asset, class: AccountingModule::Asset do
    end

    factory :liability, class: AccountingModule::Liability do
    end

    factory :equity, class: AccountingModule::Equity do
    end
  end
end
