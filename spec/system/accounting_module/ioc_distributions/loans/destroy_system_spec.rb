require "rails_helper"

describe "Destroy cart amount for share capital" do 
  it "valid", js: true  do 
    bookkeeper = create(:bookkeeper)
    create(:net_income_config, office: bookkeeper.office)
    loan = create(:loan,office: bookkeeper.office)
  
    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link "ioc-to-loans"

    click_link "#{loan.id}-select-loan"
    fill_in "Principal", with: 100
     
    click_button "Add Amount"

    expect(page).to have_content(100)

    click_link "#{loan.id}-delete-amount"

    expect(page).to_not have_content(100)
  end
end 