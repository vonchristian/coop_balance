FactoryBot.define do
  factory :amortization_schedule, class: LoansModule::AmortizationSchedule do
    association :loan
    association :loan_application
    association :office
    date { Date.current }
    principal { 100 }
    interest { 10 }
  end
end 
