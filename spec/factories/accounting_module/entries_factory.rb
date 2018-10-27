FactoryBot.define do
  factory :entry, :class => AccountingModule::Entry do |entry|
    entry.description 'entry description'
    association :recorder, factory: :user
    association :office
    association :cooperative
    entry.previous_entry_id nil
    factory :entry_with_credit_and_debit, :class => AccountingModule::Entry do |entry_cd|
      entry_cd.after(:build) do |t|
        t.credit_amounts << build(:credit_amount, :entry => t)
        t.debit_amounts << build(:debit_amount, :entry => t)
      end
    end
  end
end
