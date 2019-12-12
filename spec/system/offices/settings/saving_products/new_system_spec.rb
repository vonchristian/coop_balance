require 'rails_helper'
include ChosenSelect
describe 'New saving product' do
  before(:each) do
    manager                           = create(:general_manager)
    office                            = manager.office
    cooperative                       = manager.cooperative
    saving_product                    = create(:saving_product, name: 'Test Product', cooperative: cooperative)
    liability_account_category        = create(:liability_level_one_account_category, title: 'Test Liability', office: office)
    interest_expense_account_category = create(:expense_level_one_account_category, title: 'Test Expense', office: office)
    closing_account_category          = create(:revenue_level_one_account_category, title: 'Test Closing', office: office)
    forwarding_account                = create(:liability, name: 'Test Forwarding Account')
    office.accounts << forwarding_account
    login_as(manager, scope: :user)
    visit office_path(office)
    click_link "#{office.id}-settings"
    click_link "Saving Products"
    click_link 'New Saving Product'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Test Product', from: 'Saving product'
    select_from_chosen 'Test Liability', from: 'Liability account category'
    select_from_chosen 'Test Expense', from: 'Interest expense account category'
    select_from_chosen 'Test Closing', from: 'Closing account category'
    select_from_chosen 'Test Forwarding Account', from: 'Forwarding account'

    click_button "Save Saving Product"

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button 'Save Saving Product'

    expect(page).to have_content "can't be blank"
  end 
end
