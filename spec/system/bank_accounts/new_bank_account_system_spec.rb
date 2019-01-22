require 'rails_helper'

feature "Create bank account" do
  before(:each) do
    cooperative = create(:cooperative)
    cash_account = create(:asset, name: "Cash in Bank", active: true)
    revenue = create(:revenue, name: "Interest Income fron Deposits", active: true)
    cooperative.accounts << cash_account
    cooperative.accounts << revenue
    user = create(:treasurer)
    user.cash_accounts << cash_account
    login_as(user, :scope => :user)
    visit bank_accounts_url
    click_link 'New Bank Account'
  end

  scenario 'with valid attributes' do
    save_and_open_page
    fill_in "Bank name", with: "Land Bank"
    fill_in "Bank address", with: "Lagawe, Ifugao"
    fill_in "Account number", with: "4322342342"
    select "Cash in Bank"
    select "Interest Income from Deposits"
    click_button "Proceed"
  end
end
