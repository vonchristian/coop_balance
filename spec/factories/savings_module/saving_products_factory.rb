FactoryBot.define do
  factory :saving_product, class: 'SavingsModule::SavingProduct' do
    interest_rate { 0.02 }
    interest_recurrence { 'quarterly' }
    minimum_balance { 1_000 }
    sequence(:name, &:to_s)
    cooperative
    office
    closing_account factory: %i[revenue]
  end
end
