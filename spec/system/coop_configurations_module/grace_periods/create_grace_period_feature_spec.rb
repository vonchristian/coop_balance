require 'rails_helper'

describe 'Create grace period' do
  before do
    user = create(:user)
    login_as(user, scope: :user)
    visit management_module_settings_url
    click_link 'Set Grace Period'
  end

  it 'with valid attributes' do
    fill_in 'Number of days', with: 7
    click_button 'Save Grace Period'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Save Grace Period'

    expect(page).to have_content("can't be blank")
  end
end