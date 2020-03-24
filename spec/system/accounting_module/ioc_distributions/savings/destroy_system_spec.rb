require "rails_helper"

describe "Destroy cart amount for savings" do 
  it "valid", js: true  do 
    bookkeeper = create(:bookkeeper)
    create(:net_income_config, office: bookkeeper.office)
    @savings_account = create(:saving,office: bookkeeper.office, account_owner_name: "Juan")
    @savings_account_2 = create(:saving,office: bookkeeper.office, account_owner_name: "Manny")

    login_as(bookkeeper, scope: :user)
    visit accounting_module_ioc_distributions_path
    click_link "ioc-to-savings"

    click_link "#{@savings_account.id}-select-saving"
    fill_in "Amount", with: 100
     
    click_button "Add Amount"

    expect(page).to have_content(100)

    click_link "#{@savings_account.id}-delete-amount"

    expect(page).to_not have_content(100)
  end 
end 