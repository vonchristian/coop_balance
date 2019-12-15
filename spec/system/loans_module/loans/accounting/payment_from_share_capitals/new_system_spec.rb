require 'rails_helper'

describe 'New loan payment from share capital' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    cash       = create(:asset)
    member     = create(:member)

    @share_capital = create(:share_capital, subscriber: member, office: bookkeeper.office)
    deposit = build(:entry)
    deposit.debit_amounts.build(account: cash, amount: 100_000)
    deposit.credit_amounts.build(account: @share_capital.share_capital_equity_account, amount: 100_000)
    deposit.save!

    @loan        = create(:loan, borrower: member, office: bookkeeper.office)
    disbursement = build(:entry)
    disbursement.debit_amounts.build(account: @loan.receivable_account, amount: 50_000)
    disbursement.credit_amounts.build(account: cash, amount: 50_000)
    disbursement.save!

    login_as(bookkeeper, scope: :user)
    visit loan_path(@loan)
    click_link "#{@loan.id}-accounting"
    click_link 'add-payment-from-share-capital'
    click_link "#{@share_capital.id}-select-share-capital-for-loan-payment"
  end

  it 'with valid attributes', js: true do
    fill_in 'Amount',  with: 10_000
    click_button 'Proceed'

    expect(page).to have_content('created successfully')
    fill_in 'Description',      with: "saving as payment of loan"
    fill_in 'Reference number', with: 'JEV 1'
    fill_in 'Date',             with: Date.current.strftime('%B %e, %Y')

    click_button 'Proceed'

    expect(page).to have_content('created successfully')
    page.execute_script "window.scrollBy(0,10000)"

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')

    expect(@loan.principal_balance).to eq 40_000
    expect(@share_capital.balance).to eq  90_000
  end
end
