require 'rails_helper'

describe 'Create Contribution' do
  before do
    user = create(:user, role: 'human_resource_officer')
    login_as(user, scope: :user)
    visit hr_module_settings_url
    click_link 'New Contribution'
  end

  it 'with valid attributes' do
    fill_in 'Name', with: 'PhilHealth'
    fill_in 'Amount', with: '00932'
    click_button 'Create Contribution'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Contribution'

    expect(page).to have_content("can't be blank")
  end
end
