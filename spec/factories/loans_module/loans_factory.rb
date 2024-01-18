FactoryBot.define do
  factory :loan, class: 'LoansModule::Loan' do
    loan_application
    cooperative
    office
    loan_product
    borrower factory: %i[member]
    receivable_account factory: %i[asset]
    interest_revenue_account factory: %i[revenue]
    penalty_revenue_account factory: %i[revenue]
    accrued_income_account factory: %i[asset]
    loan_aging_group
    account_number { SecureRandom.uuid }
    borrower_full_name { Faker::Name.name }

    after(:build) do |l|
      voucher = create(:voucher)
      l.disbursement_voucher ||= voucher
    end
  end
end
