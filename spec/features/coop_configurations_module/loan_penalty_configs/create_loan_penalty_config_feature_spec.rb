require 'rails_helper'

feature "Create loan penalty configuration" do 
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    visit management_module_settings_url
    click_link 'Set Loan Penalty Configuration'
  end

  scenario 'with valid attributes' do 
    fill_in "Number of days", with: 30
    fill_in "Interest rate", with: 0.02

    click_button "Save Loan Penalty Configuration"

    expect(page).to have_content("created successfully")
  end 

  scenario 'with invalid attributes' do 
    click_button "Save Loan Penalty Configuration"

    expect(page).to have_content("can't be blank")
  end
end 