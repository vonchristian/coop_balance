require 'rails_helper'

feature 'New cash receipt line item' do
  before(:each) do
    cooperative = create(:cooperative)
    cash_on_hand = create(:asset, name: "Cash on Hand (Teller)")
    revenue     = create(:revenue, name: "Sales")
    cooperative.accounts << cash_on_hand
    cooperative.accounts << revenue

    user = create(:user, role: 'teller', cooperative: cooperative)
    user.employee_cash_accounts.create(cash_account: cash_on_hand, default_account: true, cooperative: cooperative)
    login_as(user, scope: :user )
    visit treasury_module_cash_accounts_url(cash_on_hand)
    click_link "Receive"
  end
  scenario 'with valid attributes' do
    select "Sales"
    fill_in "Amount", with: 100_000
    click_button "Add"

    expect(page).to have_content('Added successfully')
  end
end
