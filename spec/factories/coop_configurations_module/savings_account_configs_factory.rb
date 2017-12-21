FactoryBot.define do
  factory :savings_account_config, class: "CoopConfigurationsModule::SavingsAccountConfig" do
    closing_account_fee 150
    association :closing_account, factory: :revenue
  end
end
