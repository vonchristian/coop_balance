FactoryBot.define do
  factory :loan_aging_group, class: LoansModule::LoanAgingGroup do
    association :office 
    association :level_two_account_category, factory: :asset_level_two_account_category
    title     { Faker::Company.bs }
    start_num { 0 }
    end_num   { 30 }
  end
end
