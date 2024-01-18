require 'rails_helper'
include ChosenSelect

describe 'Edit loan aging group' do
  before do
    loan_officer = create(:loan_officer)
    create(:loan_aging_group, title: 'Past Due (1-30 Days)', office: loan_officer.office)

    login_as(loan_officer, scope: :user)
    visit loans_module_settings_path
    click_link 'Past Due (1-30 Days)'
    click_link 'Edit'
  end

  it 'with valid attributes', :js do
    fill_in 'Title', with: 'Current'

    click_button 'Update Loan Aging Group'

    expect(page).to have_content('updated successfully')
  end
end