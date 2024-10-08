require 'rails_helper'
include ChosenSelect
describe 'New office loan product' do
  before do
    manager                           = create(:general_manager)
    cooperative                       = manager.cooperative
    office                            = manager.office
    create(:loan_product, name: 'Test Loan Product', cooperative: cooperative)
    create(:loan_protection_plan_provider, business_name: 'CLIMBS', cooperative: cooperative)
    forwarding_account = create(:asset, name: 'Test Forwarding Account')
    office.accounts << forwarding_account
    login_as(manager, scope: :user)

    visit office_path(office)
    click_link "#{office.id}-settings"
    click_link 'Loan Products'
    click_link 'New Loan Product'
  end

  it 'with valid attributes', :js do
    select_from_chosen 'Test Loan Product',       from: 'Loan product'
    select_from_chosen 'Test Revenue',            from: 'Interest revenue account category'
    select_from_chosen 'Test Penalty',            from: 'Penalty revenue account category'
    select_from_chosen 'CLIMBS',                  from: 'Loan protection plan provider'
    select_from_chosen 'Test Forwarding Account', from: 'Forwarding account'

    click_button 'Save Loan Product'

    expect(page).to have_content('saved successfully')
  end

  it 'with blank attributes' do
    click_button 'Save Loan Product'

    expect(page).to have_content("can't be blank")
  end
end
