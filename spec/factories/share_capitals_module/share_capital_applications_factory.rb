FactoryBot.define do
  factory :share_capital_application, class: 'ShareCapitalsModule::ShareCapitalApplication' do
    equity_account factory: %i[equity]
    office
    cooperative
    subscriber factory: %i[member]
    share_capital_product
    account_number { SecureRandom.uuid }
    date_opened    { Date.current }
  end
end
