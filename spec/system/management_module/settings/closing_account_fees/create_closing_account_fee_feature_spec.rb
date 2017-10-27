require 'rails_helper'

feature "Create closing account fee" do
  before(:each) do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    visit management_module_settings_url
  end

  scenario 'with valid attributes' do
    click_link 'Add Closing Account Fee'
    fill_in "Closing account fee", with: 150
    click_button "Save Fee"
    expect(page).to have_content("created successfully")
  end

  scenario 'with invalid attributes' do
    click_button 'Save Fee'

    expect(page).to have_content("can't be blank")
  end
end
