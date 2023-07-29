FactoryBot.define do
  factory :account, class: AccountingModule::Account do
    sequence(:name) { |n| "#{SecureRandom.uuid}"}
    code            { Faker::Number.number(digits: 12) }

    factory :asset, class: 'AccountingModule::Asset' do
      association :ledger, factory: :asset_ledger
    end

    factory :liability, class: 'AccountingModule::Liability' do
      association :ledger, factory: :liability_ledger
    end

    factory :equity, class: 'AccountingModule::Equity' do
      association :ledger, factory: :equity_ledger
    end

    factory :revenue, class: 'AccountingModule::Revenue' do
      association :ledger, factory: :revenue_ledger
    end

    factory :expense, class: 'AccountingModule::Expense' do
      association :ledger, factory: :expense_ledger
    end
  end
end
