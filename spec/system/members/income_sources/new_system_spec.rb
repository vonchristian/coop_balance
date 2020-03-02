require 'rails_helper'
include ChosenSelect
describe 'New income source' do 
  before(:each) do 
    member = create(:member)
    teller = create(:teller)
    create(:membership, office: teller.office, cooperative: teller.cooperative, cooperator: member)
    create(:income_source_category, title: 'Self Employed')
    login_as(teller, scope: :user)

    visit member_settings_path(member)
    click_link 'New Income Source'
  end 

  it 'with valid attributes', js: true do 
    fill_in 'Designation', with: 'Proprietor'
    fill_in 'Description', with: 'test business'
    select_from_chosen 'Self Employed', from: "Income Source Category"

    click_button 'Save Income Source'

    expect(page).to have_content('saved successfully')
  end 

  it 'blank attributes' do 
    click_button 'Save Income Source'

    expect(page).to have_content("can't be blank")
  end 
end 