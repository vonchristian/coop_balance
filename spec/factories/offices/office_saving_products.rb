FactoryBot.define do
  factory :office_saving_product, class: 'Offices::OfficeSavingProduct' do
    liability_ledger factory: %i[liability_ledger]
    interest_expense_ledger factory: %i[expense_ledger]
    office
    forwarding_account factory: %i[liability]
    saving_product
  end
end
