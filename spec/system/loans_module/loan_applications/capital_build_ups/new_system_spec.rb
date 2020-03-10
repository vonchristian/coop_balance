require 'rails_helper'

describe 'New loan application capital build up' do 
  before(:each) do 
    loan_officer = create(:loan_officer)
    member = create(:member)
    @loan_application = create(:loan_application, borrower: member, office: loan_officer.office)
    @share_capital = create(:share_capital, subscriber: member)
    visit new_loans_module_loan_application_voucher_path(@loan_application)

    click_link "#{@share_capital.id}-select-account"
  end 
  it "with valid attributes" do 
    fill_in "Amount", with: 100 
    
    click_button "Add Capital"

    expect(page).to have_content("added successfully")
  end 
end 
