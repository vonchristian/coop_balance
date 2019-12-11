require 'rails_helper'

describe 'Edit account' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    account    = create(:account, office: bookkeeper.office)
    login_as(bookkeeper, scope: :user)
    visit accounting_module_account_path(account)
    click_link "#{account.id}-settings"
    click_link 'Edit Account'
  end

  it 'with valid attributes' do
    fill_in 'Name', with: 'test account'
  end
end 
