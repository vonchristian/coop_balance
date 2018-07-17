require 'rails_helper'

describe 'Create Program' do
  before(:each) do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    visit management_module_settings_url
    click_link "New Program / Fees"
  end
  it 'with valid attributes' do
    account = create(:asset, name: "Mutual Aid Fund")
    fill_in "Name", with: "Mutual Aid System"
    fill_in 'Description', with: "Help in beneficiary"
    fill_in 'Amount', with: 100
    check 'Default program'
    option = first('#programAccountSelect Mutual Aid Fund').text
    select option, from: 'programAccountSelect'

    click_button "Create Program"

    expect(page).to have_content('created successfully')
  end
  it 'with invalid attributes' do
    click_button 'Create Program'
    expect(page).to have_content("can't be blank")
  end
end
