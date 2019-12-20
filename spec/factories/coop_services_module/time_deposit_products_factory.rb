FactoryBot.define do
  factory :time_deposit_product, class: CoopServicesModule::TimeDepositProduct do
    association :cooperative
    name                { Faker::Company.bs }
    minimum_deposit     { 10_000 }
    maximum_deposit     { 100_000 }
    interest_rate       { 0.12 }
    break_contract_fee  { 100 }
    break_contract_rate { 0.02 }
  end
end
