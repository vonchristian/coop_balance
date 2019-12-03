FactoryBot.define do
  factory :amount do
    amount { 100 }
    association :account



    factory :debit_amount, class: AccountingModule::DebitAmount do
      type { 'AccountingModule::DebitAmount' }
    end

    factory :credit_amount, class: AccountingModule::CreditAmount do
      type { 'AccountingModule::CreditAmount' }
    end
  end
end
