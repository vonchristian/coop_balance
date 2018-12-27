FactoryBot.define do
  factory :loan, class: LoansModule::Loan do
    association :borrower, factory: :member
    association :loan_product, factory: :loan_product_with_interest_config
    association :cooperative
    loan_amount { 100_000 }
    application_date { Date.today }

    factory :loan_with_interest_on_loan_charge, class: LoansModule::Loan do |loan|
      loan_amount { 100_000 }
      application_date { Date.today }
      association :loan_product, factory: :loan_product_with_interest_config

    end
    
    factory :disbursed_loan, class: LoansModule::Loan do
    end

    factory :disbursed_loan_with_amortization_schedules, class: LoansModule::Loan do
    end
  end
end
