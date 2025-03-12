require 'rails_helper'

describe 'Destroy cart amount for share capital' do
  it 'valid', :js do
    bookkeeper = create(:bookkeeper)
    create(:net_income_config, office: bookkeeper.office)
    share_capital = create(:share_capital, office: bookkeeper.office, account_owner_name: 'Juan')

    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link 'ioc-to-share-capitals'

    click_link "#{share_capital.id}-select-share-capital"
    fill_in 'Amount', with: 100

    click_button 'Add Amount'

    expect(page).to have_content(100)

    click_link "#{share_capital.id}-delete-amount"

    expect(page).to have_no_content(100)
  end
end
