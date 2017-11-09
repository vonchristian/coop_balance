FactoryBot.define do
  factory :loan_charge, class: "LoansModule::LoanCharge" do
    association :loan
    association :chargeable, factory: :charge
    optional false
  end
end
