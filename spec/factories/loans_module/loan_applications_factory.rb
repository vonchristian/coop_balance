FactoryBot.define do 
  factory :loan_application, class: LoansModule::LoanApplication do 
    association :loan_product
    association :cooperative
    association :borrower, factory: :member 
    association :receivable_account, factory: :asset 
    association :interest_revenue_account, factory: :revenue 
    account_number   { SecureRandom.uuid }
    term             { 12 }
    application_date { Date.current }
  end
end