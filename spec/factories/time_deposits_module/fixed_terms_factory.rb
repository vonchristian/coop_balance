FactoryBot.define do
  factory :fixed_term, class: "TimeDepositsModule::FixedTerm" do
    association :time_deposit
    deposit_date nil
    maturity_date nil
    number_of_days 1
  end
end
