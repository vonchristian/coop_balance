require 'rails_helper'

describe 'New share capital capital build up' do
  before do
    cash_on_hand = create(:asset, name: 'Cash on Hand (Teller)')
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    user.cash_accounts << cash_on_hand
    @share_capital   = create(:share_capital, office: user.office)
    capital_build_up = build(:entry)
    capital_build_up.debit_amounts.build(amount: 1000, account: cash_on_hand)
    capital_build_up.credit_amounts.build(amount: 1000, account: @share_capital.share_capital_equity_account)
    capital_build_up.save!
    visit share_capital_path(@share_capital)
    click_link 'Add Capital'
  end

  it 'with valid attributes', :js do
    fill_in 'Date', with: Date.current.strftime('%B %e, %Y')
    fill_in 'Amount', with: 100_000
    fill_in 'Description', with: 'test'
    fill_in 'Reference Number', with: '909045'

    click_button 'Proceed'
    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end

  it 'with invalid attributes' do
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end
end
