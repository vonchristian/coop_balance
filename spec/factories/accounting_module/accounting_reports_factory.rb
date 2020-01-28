FactoryBot.define do
  factory :accounting_report, class: AccountingModule::AccountingReport do
    title { Faker::Company.bs }
    association :office 
    report_type { 'income_statement' }
  end
end
