require 'rails_helper'

describe "Create closing account fee" do
  before(:each) do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    visit management_module_settings_url
    click_link 'Add Closing Account Fee'
  end

 it 'with valid attributes' do
    fill_in "Closing account fee", with: 150
    click_button "Save Fee"
    expect(page).to have_content("saved successfully")
  end

  it 'with invalid attributes' do
    click_button 'Save Fee'

    expect(page).to have_content("not a number")
  end
end
