require 'rails_helper'

describe "New IOC to share capital" do 
  before(:each) do 
    bookkeeper = create(:bookkeeper)
    create(:net_income_config, office: bookkeeper.office)
    @savings_account = create(:saving,office: bookkeeper.office, account_owner_name: "Juan")
    @savings_account_2 = create(:saving,office: bookkeeper.office, account_owner_name: "Manny")

    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link "ioc-to-savings"
  end 

  it "with search params", js: true do 
    fill_in "saving-search-form", with: "Juan"

    click_button "Search"

    expect(page).to have_content("JUAN")
    expect(page).to_not have_content("MANNY")
  end

  it "with valid attributes", js: true do 
    click_link "#{@savings_account.id}-select-saving"
    fill_in "Amount", with: 100
     
    click_button "Add Amount"
    fill_in "Date",             with: Date.current 
    fill_in "Reference number", with: 'test ref'
    fill_in "Description",      with: 'test desc'

    click_button "Proceed"

    click_link "Confirm Transaction"

    expect(page).to have_content("confirmed successfully.")
  end 

  it "with blank attributes" do 
    click_link "#{@savings_account.id}-select-saving"

    click_button "Add Amount"

    expect(page).to have_content("can't be blank")
  end 
end 