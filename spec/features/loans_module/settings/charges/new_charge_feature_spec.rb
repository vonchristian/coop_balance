require 'rails_helper'

feature 'Create Property' do
	before(:each) do 
    user = create(:user, role: 'loan_officer')
    login_as(user, :scope => :user)
    member = create(:member)
    visit loans_module_settings_path
    click_link 'New Charge'
  end

  scenario 'with valid attributes' do 
  	fill_in "Name", with: "Service Fee"
  	fill_in 'Amount', with: 500

  	click_button "Create Charge"

  	expect(page).to have_content 'created successfully'
  end 
end 