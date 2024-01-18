FactoryBot.define do
  factory :time_deposit_application, class: 'TimeDepositsModule::TimeDepositApplication' do
    time_deposit_product
    liability_account factory: %i[liability]
    cooperative
    office
    depositor factory: %i[member]
    account_number { SecureRandom.uuid }
    date_deposited { Date.current }
    number_of_days { 90 }
  end
end
