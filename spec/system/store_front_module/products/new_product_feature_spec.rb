require 'rails_helper'

describe "Create product" do
	before(:each) do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    visit store_front_module_products_url
    click_link 'New Product'
  end

	it 'with valid attributes' do
		fill_in "Name", with: "Test Product"
		fill_in "Description", with: "Test Description"
		fill_in "Unit of measurement code", with: "Test Unit"
    fill_in "Unit of measurement description", with: "Test Unit"
    fill_in 'Quantity', with: 1
    fill_in 'Price', with: 500
		click_button "Create Product"

		expect(page).to have_content("created successfully")
	end

	it 'with invalid attributes' do
		click_button 'Create Product'

		expect(page).to have_content("can't be blank")
	end
end
