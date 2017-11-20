FactoryBot.define do
  factory :fixed_term, class: "TimeDepositsModule::FixedTerm" do
    association :time_deposit
    deposit_date "2017-11-20 19:00:20"
    maturity_date "2017-11-20 19:00:20"
    number_of_days 1
  end
end
