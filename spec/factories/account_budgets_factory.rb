FactoryBot.define do
  factory :account_budget do
    cooperative
    account factory: %i[revenue]
    proposed_amount { 100_000 }
    year { Date.current.year }
  end
end
