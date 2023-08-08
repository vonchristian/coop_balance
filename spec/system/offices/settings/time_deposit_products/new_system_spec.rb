require 'rails_helper'
include ChosenSelect
describe 'New saving product' do
  before(:each) do
    manager                           = create(:general_manager)
    office                            = manager.office
    cooperative                       = manager.cooperative
    time_deposit_product              = create(:time_deposit_product, name: 'Test Product', cooperative: cooperative)
    forwarding_account                = create(:liability, name: 'Test Forwarding Account')
    office.accounts << forwarding_account
    login_as(manager, scope: :user)
    visit office_path(office)
    click_link "#{office.id}-settings"
    click_link "Time Deposit Products"
    click_link 'New Time Deposit Product'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Test Product', from: 'Time deposit product'
    select_from_chosen 'Test Liability', from: 'Liability account category'
    select_from_chosen 'Test Expense', from: 'Interest expense account category'
    select_from_chosen 'Test Break Contract', from: 'Break contract account category'
    select_from_chosen 'Test Forwarding Account', from: 'Forwarding account'

    click_button "Save Time Deposit Product"

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button 'Save Time Deposit Product'

    expect(page).to have_content "can't be blank"
  end
end
