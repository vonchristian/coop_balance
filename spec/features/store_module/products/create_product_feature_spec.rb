require 'rails_helper'

feature "Create product" do 
	before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    visit products_url
    click_link 'New Product'
  end

	scenario 'with valid attributes' do 
		fill_in "Name", with: "Test Product"
		fill_in "Description", with: "Test Description"
		fill_in "Unit", with: "Test Unit"
		click_button "Create Product"

		expect(page).to have_content("created successfully")
	end 

	scenario 'with invalid attributes' do 
		click_button 'Create Product'

		expect(page).to have_content("can't be blank")
	end
end 