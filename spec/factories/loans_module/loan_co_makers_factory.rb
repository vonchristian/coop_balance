FactoryBot.define do
  factory :loan_co_maker, class: LoansModule::LoanCoMaker do
    loan { nil }
    co_maker { nil }
  end
end
