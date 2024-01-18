require 'rails_helper'
include ChosenSelect
describe 'New office net income config' do
  before do
    manager = create(:general_manager)
    net     = create(:equity, name: 'Net Surplus')
    loss    = create(:equity, name: 'Net Loss')
    revenue = create(:revenue, name: 'Total Revenues')
    expense = create(:expense, name: 'Total Expenses')
    manager.office.accounts << net
    manager.office.accounts << loss
    manager.office.accounts << revenue
    manager.office.accounts << expense

    login_as(manager, scope: :user)

    visit office_path(manager.office)
    click_link "#{manager.office_id}-settings"
    click_link 'Net Income Configurations'
    click_link 'New Config'
  end

  it 'with valid attributes', :js do
    choose 'Annually'
    select_from_chosen 'Net Surplus', from: 'Net surplus account'
    select_from_chosen 'Net Loss', from: 'Net loss account'
    select_from_chosen 'Total Revenues', from: 'Total revenue account'
    select_from_chosen 'Total Expenses', from: 'Total expense account'

    click_button 'Save Config'

    expect(page).to have_content('saved successfully')
  end
end