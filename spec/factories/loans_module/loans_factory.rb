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
    after(:build) do |l|
      voucher                = create(:voucher)
      l.disbursement_voucher ||= voucher
      l.accounts << l.receivable_account
      l.accounts << l.interest_revenue_account
      l.accounts << l.penalty_revenue_account
    end
  end
end
