require 'rails_helper'

describe 'Share capital accounting index page' do
  before(:each) do
    bookkeeper     = create(:bookkeeper)
    teller         = create(:teller)
    cash_account   = create(:asset)
    teller.cash_accounts << cash_account
    @share_capital = create(:share_capital, office: bookkeeper.office)
    entry = build(:entry)
    entry.debit_amounts.build(amount: 100, account: cash_account)
    entry.credit_amounts.build(amount: 100, account: @share_capital.share_capital_equity_account)
    entry.save!

    
    login_as(bookkeeper, scope: :user)


    visit share_capital_path(@share_capital)
    click_link "#{@share_capital.id}-accounting"
  end

  it 'with valid attributes', js: true do
    expect(page).to have_content('Accounting Section')
    expect(page).to have_content(@share_capital.share_capital_equity_account_name)
  end
end
