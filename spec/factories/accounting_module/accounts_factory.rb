FactoryBot.define do
  factory :account, class: 'AccountingModule::Account' do
    sequence(:name) { |_n| SecureRandom.uuid.to_s }
    code            { Faker::Number.number(digits: 12) }
    office

    factory :asset, class: 'AccountingModule::Asset' do
      ledger factory: %i[asset_ledger]
    end

    factory :liability, class: 'AccountingModule::Liability' do
      ledger factory: %i[liability_ledger]
    end

    factory :equity, class: 'AccountingModule::Equity' do
      ledger factory: %i[equity_ledger]
    end

    factory :revenue, class: 'AccountingModule::Revenue' do
      ledger factory: %i[revenue_ledger]
    end

    factory :expense, class: 'AccountingModule::Expense' do
      ledger factory: %i[expense_ledger]
    end
  end
end
