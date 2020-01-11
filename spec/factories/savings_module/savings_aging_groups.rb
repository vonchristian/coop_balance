FactoryBot.define do
  factory :savings_aging_group, class: SavingsModule::SavingsAgingGroup do
    association :office 
    start_num { 0 }
    end_num   { 30 }
    title     { "0-30 Days" }
  end
end
