FactoryBot.define do
  factory :saving, class: MembershipsModule::Saving do
    association :cooperative
    association :office
    association :depositor, factory: :member
    association :saving_product
    association :liability_account, factory: :liability
    association :interest_expense_account, factory: :expense
    account_number { SecureRandom.uuid }
    last_transaction_date { Date.current }
    after(:build) do |s|
      if s.liability_account.present?
        s.accounts << s.liability_account
      end 
      if s.interest_expense_account.present?
        s.accounts << s.interest_expense_account
      end 
    end 
  end
end
