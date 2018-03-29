require 'rails_helper'

feature 'Show product' do
  before(:each) do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    product = create(:product, name: "Test Product")
    visit store_front_module_products_url
  end
  scenario 'with a valid product' do
    click_link 'Test Product'
    expect(page).to have_content 'Test Product'
  end
end
