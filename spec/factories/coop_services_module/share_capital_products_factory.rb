FactoryBot.define do
  factory :share_capital_product, class: "Cooperatives::ShareCapitalProduct" do
    name                               { Faker::Name.unique.name }
    cost_per_share                     { 100 }
    minimum_number_of_paid_share       { 10 }
    minimum_number_of_subscribed_share { 25 }
    closing_account_fee                { 150 }
    has_closing_account_fee            { true }
    association :equity_account, factory: :equity

  end
end
