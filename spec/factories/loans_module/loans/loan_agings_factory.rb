FactoryBot.define do
  factory :loan_aging, class: 'LoansModule::Loans::LoanAging' do
    loan
    loan_aging_group
    receivable_account factory: %i[asset]
    date { Date.current }
  end
end
