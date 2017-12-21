require 'rails_helper'

describe 'New share capital capital build up' do
  before(:each) do
    cash_on_hand_account = create(:asset, name: "Cash on Hand (Teller)")
    user = create(:user, role: 'teller', cash_on_hand_account: cash_on_hand_account)
    login_as(user, scope: :user )
    share_capital = create(:share_capital)
    visit share_capital_url(share_capital)
    click_link "New Capital Build Up"
  end

  it 'with valid attributes' do
    fill_in 'Number of Shares', with: 1
    fill_in  "Or number", with: '909045'
    fill_in "Amount", with: 100_000

    click_button "Save Capital Build Up"

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button "Save Capital Build Up"

    expect(page).to have_content("can't be blank")
  end
end
