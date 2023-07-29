FactoryBot.define do
  factory :loan_aging_group, class: LoansModule::LoanAgingGroup do
    association :office 
    association :receivable_ledger, factory: :asset_ledger
    title     { Faker::Company.bs }
    start_num { 0 }
    end_num   { 30 }
  end
end
