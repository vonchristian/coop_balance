FactoryBot.define do
  factory :account, :class => AccountingModule::Account do |account|
    name { Faker::Company.name }
    code  { Faker::Number.number(12) }
    contra false

    factory :asset, class: "AccountingModule::Asset" do

    end
    factory :liability, class: "AccountingModule::Liability" do

    end
    factory :equity, class: "AccountingModule::Equity" do

    end
    factory :expense, class: "AccountingModule::Expense" do

    end
    factory :revenue, class: "AccountingModule::Revenue" do

    end
  end
end
