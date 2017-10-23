FactoryBot.define do
  factory :collateral, class: "LoansModule::Collateral" do
    loan nil
    real_property nil
  end
end
