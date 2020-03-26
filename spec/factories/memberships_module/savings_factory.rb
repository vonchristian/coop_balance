FactoryBot.define do
  factory :saving, class: MembershipsModule::Saving do
    association :cooperative
    association :office
    association :depositor, factory: :member
    association :saving_product
    association :liability_account, factory: :liability
    association :interest_expense_account, factory: :expense
    account_number { SecureRandom.uuid }
    after(:save) do |saving|
      saving.accounts << saving.liability_account
      saving.accounts << saving.interest_expense_account
    end 
  end
end
