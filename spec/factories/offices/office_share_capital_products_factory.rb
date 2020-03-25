FactoryBot.define do
  factory :office_share_capital_product, class: Offices::OfficeShareCapitalProduct do
    association :share_capital_product
    association :office
    association :equity_account_category, factory: :equity_level_one_account_category
    association :forwarding_account ,     factory: :equity
  end
end
