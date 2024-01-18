require 'rails_helper'

describe 'Reports index page' do
  it 'is valid' do
    user = create(:user, role: 'loan_officer')
    login_as(user, scope: :user)
    visit loans_module_reports_url

    expect(page).to have_content('Reports')
  end
end
