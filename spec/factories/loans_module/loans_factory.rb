FactoryBot.define do
  factory :loan, class: LoansModule::Loan do
    association :cooperative
    association :office
    association :loan_product
    association :borrower,                 factory: :member
    association :receivable_account,       factory: :asset
    association :interest_revenue_account, factory: :revenue
    association :penalty_revenue_account,  factory: :revenue
    association :accrued_income_account,   factory: :asset


    account_number { SecureRandom.uuid }
    after(:build) do |l|
      voucher                = create(:voucher)
      term                   = create(:term)
      l.disbursement_voucher = voucher
      l.term                 = term
    end 
  end
end
