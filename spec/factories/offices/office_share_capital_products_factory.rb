FactoryBot.define do
  factory :office_share_capital_product, class: 'Offices::OfficeShareCapitalProduct' do
    share_capital_product
    office
    equity_ledger factory: %i[equity_ledger]
    forwarding_account factory: %i[equity]
  end
end
