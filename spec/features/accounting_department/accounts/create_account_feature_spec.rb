require 'rails_helper'

feature "Create Account" do
  before(:each) do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
    visit accounting_department_accounts_url
    click_link 'New Account'
  end

  scenario 'with valid attributes' do
    fill_in "Name", with: "Cash on Hand"
    fill_in "Code", with: "00932"
    select "AccountingDepartment::Asset"

    click_button "Create Account"

    expect(page).to have_content("created successfully")
  end

  scenario 'with invalid attributes' do
    click_button "Create Account"

    expect(page).to have_content("can't be blank")
  end
end
