require 'rails_helper'
include ChosenSelect

describe 'New loan payment' do
  before do
    teller       = create(:teller)
    cash_account = create(:asset, name: 'Cash on Hand')
    loan         = create(:loan, paid_at: nil, office: teller.office)
    teller.cash_accounts << cash_account
    loan.accounts        << loan.receivable_account

    # disbursement
    disbursement = build(:entry, entry_date: Date.current)
    disbursement.credit_amounts.build(amount: 10_000, account: cash_account)
    disbursement.debit_amounts.build(amount: 10_000, account: loan.receivable_account)
    disbursement.save!

    login_as(teller, scope: :user)
    visit loan_path(loan)

    click_link "#{loan.id}-payments"
    click_link 'New Payment'
  end

  it 'with valid attributes', :js do
    fill_in 'Date', with: Date.current

    fill_in 'Description',      with: 'Loan payment'
    fill_in 'Principal amount', with: 500
    fill_in 'Interest amount',  with: 50
    fill_in 'Penalty amount',   with: 100
    fill_in 'Reference number', with: '42342'
    page.execute_script 'window.scrollBy(0,10000)'
    select_from_chosen 'Cash on Hand', from: 'Cash account'

    click_button 'Proceed'

    expect(page).to have_content('created successfully')

    click_link 'Confirm'

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end
end
