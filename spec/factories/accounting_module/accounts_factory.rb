FactoryBot.define do
  factory :account, :class => AccountingModule::Account do |account|
    sequence(:name) { |n| "Account " +  ('a'..'z').to_a.shuffle.join }
    code  { Faker::Number.number(12) }
    contra { false }


    factory :asset, class: AccountingModule::Asset do
    end

    factory :liability, class: AccountingModule::Liability do
    end

    factory :equity, class: AccountingModule::Equity do
    end

    factory :expense, class: AccountingModule::Expense do
    end

    factory :revenue, class: AccountingModule::Revenue do
      sequence(:name) { |n| "Revenue Account " +  ('a'..'z').to_a.shuffle.join }
    end
  end
end
