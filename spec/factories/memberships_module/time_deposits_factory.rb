FactoryBot.define do
  factory :time_deposit, class: MembershipsModule::TimeDeposit do
    association :depositor, factory: :member
    association :cooperative
    association :office
    association :time_deposit_product
    association :liability_account, factory: :liability
    association :interest_expense_account, factory: :expense
    account_number { SecureRandom.uuid }
  end
end 
