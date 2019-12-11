FactoryBot.define do
  factory :term do
    term { 1 }
    effectivity_date { Date.current }
    maturity_date { Date.current.next_month }
    association :termable, factory: :loan
  end
end 
