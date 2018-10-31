FactoryBot.define do
  factory :amount, :class => AccountingModule::Amount do
    amount BigDecimal.new('100')
    association :entry, :factory => :origin_entry
    association :account, :factory => :asset
    association :commercial_document, factory: :loan

    factory :credit_amount, :class => AccountingModule::CreditAmount do
      amount BigDecimal.new('100')
      association :entry, :factory => :origin_entry

      association :commercial_document, factory: :saving
    end

    factory :debit_amount, :class => AccountingModule::DebitAmount do
      amount BigDecimal.new('100')
      association :entry, :factory => :origin_entry

      association :commercial_document, factory: :saving
    end
  end
end
