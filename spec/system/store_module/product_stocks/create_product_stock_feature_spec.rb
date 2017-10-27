require 'rails_helper'

feature "Create product stock" do 
	before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    supplier = create(:supplier, first_name: "Von Christian", last_name: "Halip")
    product = create(:product)
    visit store_module_product_url(product)

    click_link 'New Stock'
  end

	scenario 'with valid attributes' do 
		select "Von Christian Halip", :from => "supplierSelect"
		fill_in "Date", with: "02/12/2017"
		fill_in "Quantity", with: 100
		fill_in "Unit cost", with: 1
		fill_in "Total cost", with: 100
		fill_in "Barcode", with: '23131312'


		click_button "Save Stock"

		expect(page).to have_content("saved successfully")
	end 

	scenario 'with invalid attributes' do 
		click_button 'Save Stock'

		expect(page).to have_content("can't be blank")
	end
end 