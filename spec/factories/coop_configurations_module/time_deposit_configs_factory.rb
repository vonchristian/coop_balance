FactoryBot.define do
  factory :time_deposit_config, class: "CoopConfigurationsModule::TimeDepositConfig" do
    break_contract_account nil
    interest_account nil
    account nil
    break_contract_fee "9.99"
  end
end
