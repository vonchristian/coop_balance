require 'rails_helper'

describe 'New Break Contract Fee' do
  it 'with valid attributes' do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    visit management_module_settings_url
    click_link "Set Break Contract Fee"

    fill_in "Amount", with: 1_000
    click_button "Save"

    expect(page).to have_content('saved successfully')
  end
end
