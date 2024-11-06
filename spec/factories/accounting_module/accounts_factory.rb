FactoryBot.define do
  factory :account, class: 'AccountingModule::Account' do
    sequence(:name) { |n| SecureRandom.uuid.to_s }
    code            { Faker::Number.number(digits: 12) }
    office

    factory :asset, class: 'AccountingModule::Account' do
      account_type { 'asset' }
      association :ledger, factory: :asset_ledger
    end

    factory :liability, class: 'AccountingModule::Account' do
      account_type { 'liability' }
      association :ledger, factory: :liability_ledger
    end

    factory :equity, class: 'AccountingModule::Account' do
      account_type { 'equity' }
      association :ledger, factory: :equity_ledger
    end

    factory :revenue, class: 'AccountingModule::Account' do
      account_type { 'revenue' }
      association :ledger, factory: :revenue_ledger
    end

    factory :expense, class: 'AccountingModule::Account' do
      account_type { 'expense' }
      association :ledger, factory: :expense_ledger
    end
  end
end
