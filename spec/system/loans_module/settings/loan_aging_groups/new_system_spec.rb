require 'rails_helper'

describe 'New loan aging group' do
  before(:each) do
    loan_officer = create(:loan_officer)
    login_as(loan_officer, scope: :user)
    visit loans_module_settings_path
    click_link 'New Aging Group'
  end

  it 'with valid attributes' do
    fill_in 'Title', with: 'Current'
    fill_in 'Start num', with: 0
    fill_in 'End num', with: 0

    click_button 'Create Loan Aging Group'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Loan Aging Group'

    expect(page).to have_content("can't be blank")
  end
end
