FactoryBot.define do
  factory :office_share_capital_product, class: Offices::OfficeShareCapitalProduct do
    association :share_capital_product
    association :office
    association :equity_ledger, factory: :equity_ledger
    association :forwarding_account ,     factory: :equity
  end
end
