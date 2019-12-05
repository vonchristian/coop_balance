require 'rails_helper'
include ChosenSelect
describe 'New office program', type: :system do
  before(:each) do
    cooperative     = create(:cooperative)
    office          = create(:office, cooperative: cooperative)
    general_manager = create(:general_manager, cooperative: cooperative, office: office)
    program         = create(:program, name: 'Mutual Aid System', cooperative: cooperative)
    program_2       = create(:program, name: 'Membership Fee', cooperative: cooperative)
    category        = create(:equity_level_one_account_category, title: 'Mutual Aid Fund', office: office)
    create(:office_program, office: office, program: program_2)

    login_as(general_manager, scope: :user)
    visit office_path(office)
    click_link "#{office.id}-settings"
    click_link 'Programs'
    click_link 'New Program'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Mutual Aid System', from: 'Program', match: :first
    select_from_chosen 'Mutual Aid Fund',   from: 'Level one account category'

    click_button 'Create Program'

    expect(page).to have_content('created successfully')
  end

  it 'with blank attributes' do
    click_button 'Create Program'

    expect(page).to have_content("can't be blank")
  end

  it 'with duplicate program', js: true do
    select_from_chosen 'Membership Fee',  from: 'Program'
    select_from_chosen 'Mutual Aid Fund', from: 'Level one account category'

    click_button 'Create Program'

    expect(page).to have_content("has already been taken")
  end
end
