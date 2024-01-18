FactoryBot.define do
  factory :entry, class: 'AccountingModule::Entry' do
    description { Faker::Company.bs }
    commercial_document factory: %i[member]
    entry_date       { Date.current }
    entry_time       { Time.zone.now }
    reference_number { 'test ref #' }
    after(:build) do |t|
      cooperative   = create(:cooperative)
      office        = create(:office, cooperative: cooperative)
      recorder      = create(:teller, office: office, cooperative: cooperative)
      t.office      ||= office
      t.cooperative ||= cooperative
      t.recorder    ||= recorder
    end

    factory :entry_with_credit_and_debit, class: 'AccountingModule::Entry' do |entry_cd|
      entry_cd.after(:build) do |t|
        t.credit_amounts << FactoryBot.build(:credit_amount, entry: t)
        t.debit_amounts << FactoryBot.build(:debit_amount, entry: t)
      end
    end
  end
end
