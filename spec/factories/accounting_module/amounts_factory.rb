FactoryBot.define do
  factory :amount, :class => AccountingModule::Amount do
    amount { BigDecimal('100') }
    factory :credit_amount, :class => AccountingModule::CreditAmount do
      amount { BigDecimal('100') }
      association :account, factory: :asset
      association :commercial_document, factory: :saving
    end

    factory :debit_amount, :class => AccountingModule::DebitAmount do
      amount { BigDecimal('100') }
      association :account, factory: :asset
      association :commercial_document, factory: :saving
    end
  end
end
