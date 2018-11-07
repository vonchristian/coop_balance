FactoryBot.define do
  factory :origin_entry, class: AccountingModule::Entry do |entry|
    entry.association :cooperative
    entry.association :office
    entry.description  "Genesis entry"
    entry.association :recorder, factory: :user
    entry.reference_number "Genesis"
    entry.previous_entry_id ""
    entry.previous_entry_hash "Genesis previous entry hash"
    entry.encrypted_hash "Genesis encrypted hash"
    entry.entry_date  Date.today
    entry.after(:build) do |t|
      t.credit_amounts << build(:credit_amount, entry: t, amount: 0)
      t.debit_amounts << build(:debit_amount, entry: t, amount: 0)
    end
  end

  factory :entry, :class => AccountingModule::Entry do |entry|
    entry.description 'entry description'
    association :recorder, factory: :user
    association :office
    association :cooperative, factory: :origin_cooperative
    entry.previous_entry_id nil
    factory :entry_with_credit_and_debit, :class => AccountingModule::Entry do |entry_cd|
      entry_cd.after(:build) do |t|
        t.credit_amounts << build(:credit_amount, :entry => t)
        t.debit_amounts << build(:debit_amount, :entry => t)
      end
    end
  end
end
