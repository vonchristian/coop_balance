FactoryBot.define do
  factory :loan, class: LoansModule::Loan do
    association :loan_application
    association :cooperative
    association :office
    association :loan_product
    association :borrower,                 factory: :member
    association :receivable_account,       factory: :asset
    association :interest_revenue_account, factory: :revenue
    association :penalty_revenue_account,  factory: :revenue
    association :accrued_income_account,   factory: :asset
    association :loan_aging_group
    account_number { SecureRandom.uuid }
    borrower_full_name { Faker::Name.name }

    after(:build) do |l|
      voucher                = create(:voucher)
      l.disbursement_voucher ||= voucher
      
    end
  end
end
