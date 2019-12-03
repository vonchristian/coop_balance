FactoryBot.define do
  factory :entry, class: AccountingModule::Entry do
    association :recorder, factory: :user
    association :office
    association :cooperative
    description { Faker::Company.bs }
    after(:build) do |t|
        t.credit_amounts << FactoryBot.build(:credit_amount, :entry => t)
        t.debit_amounts << FactoryBot.build(:debit_amount, :entry => t)
      end
  end
end
