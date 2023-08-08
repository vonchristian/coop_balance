require 'rails_helper'
include ChosenSelect

describe 'New share capital product' do
  before(:each) do
    manager                 = create(:general_manager)
    office                  = manager.office
    cooperative             = manager.cooperative
    share_capital_product   = create(:share_capital_product, name: 'Test Share Capital Product', cooperative: cooperative)
    forwarding_account      = create(:equity, name: 'Test Account')
    office.accounts << forwarding_account
    login_as(manager, scope: :user)
    visit office_path(office)
    click_link "#{office.id}-settings"
    click_link 'Share Capital Products'
    click_link 'New Share Capital Product'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Test Share Capital Product', from: 'Share capital product'
    select_from_chosen 'Test Equity',                from: 'Equity account category'
    select_from_chosen 'Test Account',               from: 'Forwarding account'

    click_button 'Save Share Capital Product'

    expect(page).to have_content('saved successfully')
  end

  it 'with blank attributes' do
    click_button 'Save Share Capital Product'

    expect(page).to have_content("can't be blank")
  end

end
