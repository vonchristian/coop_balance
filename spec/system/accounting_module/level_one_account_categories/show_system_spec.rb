require 'rails_helper'

describe 'L1 account category show page' do 
  it 'valid', js: true do 
    bookkeeper          = create(:bookkeeper)
    l1_account_category = create(:asset_level_one_account_category, title: 'Test L1 Account Category', office: bookkeeper.office)

    login_as(bookkeeper, scope: :user)
    visit accounting_module_level_one_account_categories_path

    expect(page).to have_content 'Test L1 Account Category'
    click_link 'Test L1 Account Category'
  end 
end 