FactoryBot.define do
  factory :time_deposit, class: MembershipsModule::TimeDeposit do
    association :depositor, factory: :member
    association :cooperative
    association :office
    association :time_deposit_product
    association :liability_account, factory: :liability
    association :interest_expense_account, factory: :expense
    association :break_contract_account, factory: :revenue

    account_number { SecureRandom.uuid }
    date_deposited { Date.current }
    association :term
  end
end
