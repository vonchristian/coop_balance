FactoryGirl.define do
  factory :amount, :class => AccountingModule::Amount do |amount|
    amount.amount BigDecimal.new('100')
    amount.association :entry, :factory => :entry_with_credit_and_debit
    amount.association :account, :factory => :asset
  end

  factory :credit_amount, :class => AccountingModule::CreditAmount do |credit_amount|
    credit_amount.amount BigDecimal.new('100')
    credit_amount.association :entry, :factory => :entry_with_credit_and_debit
    credit_amount.association :account, :factory => :revenue
  end

  factory :debit_amount, :class => AccountingModule::DebitAmount do |debit_amount|
    debit_amount.amount BigDecimal.new('100')
    debit_amount.association :entry, :factory => :entry_with_credit_and_debit
    debit_amount.association :account, :factory => :asset
  end
end