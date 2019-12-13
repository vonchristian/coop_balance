require 'rails_helper'
include ChosenSelect

describe 'Edit l1 account category' do
  before(:each) do
    bookkeeper    = create(:bookkeeper)
    l2_category   = create(:asset_level_two_account_category, title: 'L2 Test Category', office: bookkeeper.office)
    l1_category   = create(:asset_level_one_account_category,  office: bookkeeper.office)
    l1_category_2 = create(:asset_level_one_account_category, title: 'L1 Test Category', office: bookkeeper.office)
    login_as(bookkeeper, scope: :user)
    visit accounting_module_level_one_account_categories_path
    click_link l1_category.title
    click_link "#{l1_category.id}-settings"
    click_link 'Update Category'
  end

  it 'with valid attributes', js: true do
    fill_in 'Title', with: 'test category'
    fill_in 'Code',  with: 'test code'
    choose 'AccountingModule::AccountCategories::LevelOneAccountCategories::Liability'
    check 'Contra'
    select_from_chosen 'L2 Test Category', from: 'Level two account category'

    click_button 'Update Category'

    expect(page).to have_content('updated successfully')
  end

  it 'with blank attributes' do
    fill_in 'Title', with: ''

    click_button 'Update Category'

    expect(page).to have_content("can't be blank")
  end

  it 'with duplicate attributes' do
    fill_in 'Title', with: 'L1 Test Category'

    click_button 'Update Category'

    expect(page).to have_content("has already been taken")
  end
end
