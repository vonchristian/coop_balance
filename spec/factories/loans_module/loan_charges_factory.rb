FactoryBot.define do
  factory :loan_charge, class: "LoansModule::LoanCharge" do
    association :loan
    association :charge
    association :commercial_document, factory: :saving
    optional false
  end
end
