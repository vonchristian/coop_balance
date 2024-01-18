FactoryBot.define do
  factory :share_capital_product, class: 'CoopServicesModule::ShareCapitalProduct' do
    cooperative
    equity_account factory: %i[equity]
    interest_payable_account factory: %i[equity]
    transfer_fee_account factory: %i[revenue]
    transfer_fee   { 100 }
    name           { Faker::Company.bs }
    cost_per_share { 50 }
    minimum_number_of_paid_share { 10 }
  end
end
