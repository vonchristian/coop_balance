require 'rails_helper'

describe 'New cooperative' do
  before(:each) do
    user = create(:manager)
    login_as(user, scope: :user)
    visit management_module_settings_url
    click_link "Update Cooperative Details"
  end

  it 'with valid attributes' do
    fill_in "Name", with: "Kiangan Community Multipurpose Cooperative"
    fill_in "Abbreviated name", with: "KCMDC"
    fill_in "Registration number", with: '009-9900990'
    click_button "Save Cooperative Details"

    expect(page).to have_content('saved successfully')
  end
end
