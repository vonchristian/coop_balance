FactoryBot.define do
  factory :loan_application, class: 'LoansModule::LoanApplication' do
    loan_product
    cart
    cooperative
    office
    borrower factory: %i[member]
    receivable_account factory: %i[asset]
    interest_revenue_account factory: %i[revenue]
    preparer factory: %i[loan_officer]
    voucher
    account_number   { SecureRandom.uuid }
    term             { 12 }
    application_date { Date.current }
    number_of_days   { 60 }
  end
end
