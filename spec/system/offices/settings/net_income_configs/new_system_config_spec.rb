require 'rails_helper'
include ChosenSelect
describe 'New office net income config' do 
  before(:each) do 
    manager = create(:general_manager)
    net     = create(:equity, name: 'Net Surplus')
    loss    = create(:equity, name: 'Net Loss')
    manager.office.accounts << net
    manager.office.accounts << loss

    login_as(manager, scope: :user)

    visit office_path(manager.office)
    click_link "#{manager.office.id}-settings"
    click_link 'Net Income Configurations'
    click_link 'New Config'
  end 

  it 'with valid attributes', js: true do 
    choose "Annually"
    select_from_chosen "Net Surplus", from: 'Net surplus account'
    select_from_chosen "Net Loss", from: 'Net loss account'


    click_button "Save Config"

    expect(page).to have_content("saved successfully")
  end 
end 