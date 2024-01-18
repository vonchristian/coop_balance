FactoryBot.define do
  factory :ledger, class: 'AccountingModule::Ledger' do
    code { SecureRandom.uuid }
    name { 'MyString' }
    contra { false }

    factory :asset_ledger, class: 'AccountingModule::Ledger' do
      account_type { 'asset' }
    end

    factory :liability_ledger, class: 'AccountingModule::Ledger' do
      account_type { 'liability' }
    end

    factory :equity_ledger, class: 'AccountingModule::Ledger' do
      account_type { 'equity' }
    end

    factory :revenue_ledger, class: 'AccountingModule::Ledger' do
      account_type { 'revenue' }
    end

    factory :expense_ledger, class: 'AccountingModule::Ledger' do
      account_type { 'expense' }
    end
  end
end
