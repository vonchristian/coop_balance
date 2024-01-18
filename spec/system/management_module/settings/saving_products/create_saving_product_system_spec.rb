require 'rails_helper'

describe 'Create saving product' do
  before do
    user = create(:user, role: 'manager')
    login_as(user, scope: :user)
    create(:liability, name: 'Savings Deposits')
    visit management_module_settings_url
    click_link 'New Saving Product'
  end

  it 'with valid attributes' do
    fill_in 'Name', with: 'Regular Savings'
    fill_in 'Interest rate', with: '0.02'
    choose 'Quarterly'
    select 'Savings Deposits', from: 'savingProductAccountSelect'
    click_button 'Create Saving Product'

    expect(page).to have_content('created successfully')
  end
end
