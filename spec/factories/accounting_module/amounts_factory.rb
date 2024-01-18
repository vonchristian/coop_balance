FactoryBot.define do
  factory :amount, class: 'AccountingModule::Amount' do
    amount { 100 }
    account
    entry
    factory :debit_amount, class: 'AccountingModule::DebitAmount' do
      type { 'AccountingModule::DebitAmount' }
    end

    factory :credit_amount, class: 'AccountingModule::CreditAmount' do
      type { 'AccountingModule::CreditAmount' }
    end
  end
end
