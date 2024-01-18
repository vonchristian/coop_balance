FactoryBot.define do
  factory :time_deposit, class: 'DepositsModule::TimeDeposit' do
    depositor factory: %i[member]
    cooperative
    office
    time_deposit_product
    liability_account factory: %i[liability]
    interest_expense_account factory: %i[expense]
    break_contract_account factory: %i[revenue]

    account_number { SecureRandom.uuid }
    date_deposited { Date.current }
    term
  end
end
