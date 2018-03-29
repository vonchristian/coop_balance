require 'rails_helper'

describe "Index product" do
  before(:each) do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
  end
  scenario 'with products' do
    product = create(:product, name: "Cookies")
    product_2 = create(:product, name: "Bread")
    visit store_front_module_products_url

    expect(page).to have_content product.name
    expect(page).to have_content product_2.name
  end
  scenario 'with search params' do
    product = create(:product, name: "Cookies")
    product_2 = create(:product, name: "Bread")
    visit store_front_module_products_url
    fill_in 'product-search-form', with: "Cookies"
    click_button "Search"

    expect(page).to have_content "Cookies"
    expect(page).to_not have_content "Bread"
  end

end
