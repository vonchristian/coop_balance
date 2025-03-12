require 'rails_helper'

describe 'New IOC to share capital' do
  before do
    bookkeeper       = create(:bookkeeper)
    @share_capital   = create(:share_capital, office: bookkeeper.office, account_owner_name: 'Juan')
    @share_capital_2 = create(:share_capital, office: bookkeeper.office, account_owner_name: 'Manny')
    create(:net_income_config, office: bookkeeper.office)

    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link 'ioc-to-share-capitals'
  end

  it 'with search params', :js do
    fill_in 'share-capital-search-form', with: 'Juan'

    click_button 'Search'

    expect(page).to have_content('JUAN')
    expect(page).to have_no_content('MANNY')
  end

  it 'with valid attributes', :js do
    click_link "#{@share_capital.id}-select-share-capital"

    fill_in 'Amount', with: 100

    click_button 'Add Amount'
    fill_in 'Date',             with: Date.current
    fill_in 'Reference number', with: 'test ref'
    fill_in 'Description',      with: 'test desc'

    click_button 'Proceed'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully.')
  end

  it 'with blank attributes' do
    click_link "#{@share_capital.id}-select-share-capital"

    click_button 'Add Amount'

    expect(page).to have_content("can't be blank")
  end
end
