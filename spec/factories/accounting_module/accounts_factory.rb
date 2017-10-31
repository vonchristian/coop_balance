FactoryBot.define do
  factory :account, :class => AccountingModule::Account do |account|
    sequence(:name){|n| "account#{n} #{n} account" }
    code  { Faker::Number.number(12) }
    contra false

    factory :asset do
      type 'AccountingModule::Asset'
    end
    factory :liability do
      type 'AccountingModule::Liability'
    end
    factory :equity do
      type 'AccountingModule::Equity'
    end
    factory :expense do
      type 'AccountingModule::Expense'
    end
    factory :revenue do
      type "AccountingModule::Revenue"
    end
  end
end
