require 'rails_helper'

describe 'Index of customers' do
  before(:each) do
     user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    visit customers_url

  end

  it 'is valid' do
    expect(page).to have_content("Customers")
  end
end
