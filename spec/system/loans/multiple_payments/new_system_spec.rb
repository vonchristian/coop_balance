require 'rails_helper'
include ChosenSelect
describe 'New loan multiple payments', type: :system do
  before(:each) do
    teller   = create(:teller)
    cash     = create(:asset, name: 'Cash')
    teller.cash_accounts << cash
    member   = create(:member, first_name: 'Juan', last_name: 'Cruz')
    member_2 = create(:member, first_name: 'Juana', last_name: 'Cruz')
    loan     = create(:loan, office: teller.office, borrower: member, borrower_full_name: member.full_name)
    loan_2   = create(:loan, office: teller.office, borrower: member_2,borrower_full_name: member_2.full_name)

    disbursement = build(:entry)
    disbursement.debit_amounts.build(amount: 100_000, account: loan.receivable_account)
    disbursement.credit_amounts.build(amount: 100_000, account: cash)
    disbursement.save!

    disbursement_2 = build(:entry)
    disbursement_2.debit_amounts.build(amount: 100_000, account: loan.receivable_account)
    disbursement_2.credit_amounts.build(amount: 100_000, account: cash)
    disbursement_2.save!

    login_as(teller, scope: :user)
    visit loans_path
    click_link 'New Multiple Payments'
  end

  it 'with valid attributes', js: :true do
    fill_in 'loan-search-form', with: 'Juan'
    click_button 'search-btn', match: :first
    click_link 'Select'

    fill_in 'Principal amount', with: 100
    fill_in 'Interest amount', with: 100
    fill_in 'Penalty amount', with: 100
    select_from_chosen 'Cash', from: 'Cash account'
    click_button 'Proceed'

    expect(page).to have_content('added successfully')

    fill_in 'loan-search-form', with: 'Juana'
    click_button 'search-btn', match: :first
    click_link 'Select'

    fill_in 'Principal amount', with: 100
    fill_in 'Interest amount', with: 100
    fill_in 'Penalty amount', with: 100
    select_from_chosen 'Cash', from: 'Cash account'
    click_button 'Proceed'

    expect(page).to have_content('added successfully')

    fill_in 'Date', with: Date.current
    fill_in 'Description', with: 'test description'
    fill_in 'Reference number', with: 'test'

    click_button 'Proceed'

    expect(page).to have_content('created successfully')

    click_link 'Confirm Transaction'
    expect(page).to have_content('confirmed successfully')
  end
end