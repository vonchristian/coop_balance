FactoryBot.define do
  factory :loan_aging, class: LoansModule::Loans::LoanAging do
    association :loan
    association :loan_aging_group
    association :receivable_account, factory: :asset
    date { Date.current }
  end
end
