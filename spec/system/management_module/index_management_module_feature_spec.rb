require 'rails_helper'

feature 'visit management module' do
  scenario 'when logged in' do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    visit management_module_index_url
    expect(page).tp have_content("Management")
  end
end
