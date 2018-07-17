require 'rails_helper'

feature "Create bank account" do
  before(:each) do
    user = create(:treasurer)
    login_as(user, :scope => :user)
    visit bank_accounts_url
    click_link 'New Bank Account'
  end

  scenario 'with valid attributes' do
  end
end
