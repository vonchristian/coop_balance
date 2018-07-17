require 'rails_helper'

describe 'index settings page' do
  it 'is valid' do
    user = create(:user, role: 'sales_clerk')
    login_as(user, :scope => :user)
    visit store_front_module_settings_url
    expect(page).to have_content('Store Settings')
  end
end
