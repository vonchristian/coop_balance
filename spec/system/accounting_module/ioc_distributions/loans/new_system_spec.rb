require 'rails_helper'

describe "New IOC to loan" do 
  before(:each) do 
    bookkeeper = create(:bookkeeper)
    create(:net_income_config, office: bookkeeper.office)
    loan       = create(:loan,office: bookkeeper.office)

    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link "ioc-to-loans"
    click_link "#{loan.id}-select-loan"
  end 

  it "with valid attributes", js: true do 
    fill_in "Principal", with: 100
    fill_in "Interest",  with: 200
    fill_in "Penalty",   with: 400
     
    click_button "Add Amount"
    fill_in "Date",             with: Date.current 
    fill_in "Reference number", with: 'test ref'
    fill_in "Description",      with: 'test desc'

    click_button "Proceed"

    click_link "Confirm Transaction"

    expect(page).to have_content("confirmed successfully.")
  end 

  it "with blank attributes" do 
    click_button "Add Amount"

    expect(page).to have_content("can't be blank")
  end 
end 