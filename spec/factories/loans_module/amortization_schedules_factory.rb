FactoryBot.define do
  factory :amortization_schedule, class: 'LoansModule::AmortizationSchedule' do
    loan
    loan_application
    office
    date { Date.current }
    principal { 100 }
    interest { 10 }
  end
end
