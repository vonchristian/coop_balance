FactoryGirl.define do
  factory :entry, :class => AccountingDepartment::Entry do |entry|
    entry.description 'factory description'
    factory :entry_with_credit_and_debit, :class => AccountingDepartment::Entry do |entry_cd|
      entry_cd.after(:build) do |t|
        t.credit_amounts << FactoryGirl.build(:credit_amount, :entry => t)
        t.debit_amounts << FactoryGirl.build(:debit_amount, :entry => t)
      end
    end
  end
end