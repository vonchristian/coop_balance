
require 'rails_helper'

describe 'new accounts receivable store config' do
  it 'with valid attributes' do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    account = create(:asset, name: "Accounts Receivable - General Merchandise")
    visit store_module_settings_url
    click_link 'Set Account for Accounts Receivable'

    select 'Accounts Receivable - General Merchandise'
    click_button 'Save'

    expect(page).to have_content('saved successfully')
  end
  it 'with invalid attributes' do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    account = create(:asset, name: "Accounts Receivable - General Merchandise")
    visit store_module_settings_url
    click_link 'Set Account for Accounts Receivable'

    # select 'Accounts Receivable - General Merchandise'
    click_button 'Save'

    expect(page).to have_content("can't be blank")
  end
end
