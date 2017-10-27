require 'rails_helper'

feature "Create grace period" do 
	before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    visit management_module_settings_url
    click_link 'Set Grace Period'
  end

	scenario 'with valid attributes' do 
		fill_in "Number of days", with: 7
		click_button "Save Grace Period"

		expect(page).to have_content("created successfully")
	end 

	scenario 'with invalid attributes' do 
		click_button "Save Grace Period"

		expect(page).to have_content("can't be blank")
	end
end 