require 'rails_helper'

include ChosenSelect

describe 'New Program', type: :system do
  before(:each) do
    office   = create(:office)
    user     = create(:general_manager, office: office)
    category = create(:equity_level_one_account_category, title: 'Mutual Aid Fund', office: office)
    login_as(user, scope: :user)
    visit management_module_settings_path
    click_link 'Programs'
    click_link "New Program"
  end

  it 'with valid attributes', js: true do
    fill_in "Name",        with: "Mutual Aid System"
    fill_in 'Description', with: "Help in beneficiary"
    select_from_chosen 'Mutual Aid Fund', from: 'Level one account category'

    fill_in 'Amount',      with: 100
    choose 'Annually'
    check 'Default program'

    click_button "Create Program"

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Program'

    expect(page).to have_content("can't be blank")
  end
end
