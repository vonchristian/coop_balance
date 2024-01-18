require 'rails_helper'
include ChosenSelect
describe 'New loan aging group' do
  before do
    loan_officer = create(:loan_officer)
    create(:asset_level_two_account_category, office: loan_officer.office, title: 'Loans Receivables Current')
    login_as(loan_officer, scope: :user)
    visit loans_module_settings_path
    click_link 'New Aging Group'
  end

  it 'with valid attributes', :js do
    fill_in 'Title',     with: 'Current'
    fill_in 'Start num', with: 0
    fill_in 'End num',   with: 0
    select_from_chosen 'Loans Receivables Current', from: 'Level two account category'

    click_button 'Create Loan Aging Group'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Loan Aging Group'

    expect(page).to have_content("can't be blank")
  end
end
