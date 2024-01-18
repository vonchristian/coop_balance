FactoryBot.define do
  factory :office_time_deposit_product, class: 'Offices::OfficeTimeDepositProduct' do
    office
    time_deposit_product
    liability_ledger factory: %i[liability_ledger]
    interest_expense_ledger factory: %i[expense_ledger]
    break_contract_revenue_ledger factory: %i[revenue_ledger]
    forwarding_account factory: %i[liability]
  end
end
