require 'rails_helper'

describe 'Settings index page' do
  it 'is valid' do
    user = create(:user, role: 'accountant')
    login_as(user, scope: :user)
    visit accounting_module_settings_url

    expect(page).to have_content('Settings')
  end
end
