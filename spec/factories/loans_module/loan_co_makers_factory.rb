FactoryBot.define do
  factory :loan_co_maker, class: 'LoansModule::LoanCoMaker' do
    loan
    co_maker factory: %i[member]
  end
end