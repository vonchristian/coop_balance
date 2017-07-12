FactoryGirl.define do
  factory :time_deposit_product, class: "CoopServicesModule::TimeDepositProduct" do
    minimum_amount "9.99"
    maximum_amount "9.99"
    interest_rate "9.99"
    name "MyString"
    interest_recurrence 1
  end
end
