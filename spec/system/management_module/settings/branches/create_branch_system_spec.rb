require 'rails_helper'

describe 'Create branch' do
  before do
    cooperative = create(:cooperative, name: 'Kalanguya')
    user = create(:user, role: 'manager', cooperative: cooperative)
    login_as(user, scope: :user)

    visit management_module_settings_url
    click_link 'Kalanguya'
    click_link 'Add Branch'
  end

  it 'with valid attributes' do
    fill_in 'Branch name', with: 'Mansoyosoy'
    fill_in 'Address', with: 'Mansoyosoy, Ifugao'
    fill_in 'Contact number', with: '09347823742'
    choose 'Main Office'
    click_button 'Create Branch'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Branch'

    expect(page).to have_content("can't be blank")
  end
end
