FactoryBot.define do
  factory :term do
    association :termable, factory: :loan
    number_of_days   { 30 }
    effectivity_date { Date.current }
    maturity_date    { Date.current.next_month }
  end
end
