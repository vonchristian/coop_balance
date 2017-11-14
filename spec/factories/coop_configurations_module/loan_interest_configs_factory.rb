FactoryBot.define do
  factory :loan_interest_config, class: "CoopConfigurationsModule::LoanInterestConfig" do
    association :account, factory: :revenue
  end
end
