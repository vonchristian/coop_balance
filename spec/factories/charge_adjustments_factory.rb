FactoryBot.define do
  factory :charge_adjustment, class: "LoansModule::ChargeAdjustment" do
    loan_charge nil
    amount "9.99"
    percent "9.99"
  end
end
