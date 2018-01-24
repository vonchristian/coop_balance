FactoryBot.define do
  factory :amortization_schedule, class: "LoansModule::AmortizationSchedule" do
    loan nil
    date nil
    principal "9.99"
    interest "9.99"
  end
end
