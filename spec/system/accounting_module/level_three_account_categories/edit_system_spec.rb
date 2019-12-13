require 'rails_helper'

describe 'Edit l3 account category' do
  before(:each) do
    bookkeeper    = create(:bookkeeper)
    l3_category   = create(:asset_level_three_account_category, office: bookkeeper.office)
    l3_category_2 = create(:asset_level_three_account_category, title: 'Test Category', office: bookkeeper.office)

    login_as(bookkeeper, scope: :user)
    visit accounting_module_level_three_account_categories_path
    click_link l3_category.title
    click_link "#{l3_category.id}-settings"
    click_link 'Update Category'
  end

  it 'with valid attributes' do
    fill_in 'Title', with: 'test category'
    fill_in 'Code', with: 'test code'
    choose 'AccountingModule::AccountCategories::LevelThreeAccountCategories::Liability'
    check 'Contra'

    click_button 'Update Category'

    expect(page).to have_content('updated successfully')
  end

  it 'with blank attributes' do
    fill_in 'Title', with: ''

    click_button 'Update Category'

    expect(page).to have_content("can't be blank")
  end

  it 'with duplicate attributes' do
    fill_in 'Title', with: 'Test Category'

    click_button 'Update Category'

    expect(page).to have_content("has already been taken")
  end
end
