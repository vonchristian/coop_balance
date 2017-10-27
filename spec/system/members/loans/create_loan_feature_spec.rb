require 'rails_helper'

feature "Create loan" do 
  before(:each) do
    user = create(:loan_officer)
    login_as(user, :scope => :user)
    member = create(:member)
    visit member_loans_url(member)
    click_link 'New Loan Application'
  end

  scenario 'with valid attributes' do 
    loan_product = create(:loan_product)
    select
    click_button 'Save Application'
    expect(page).to have_content("saved successfully")
  end 

  scenario 'with invalid attributes' do 
    click_button "Save Application"

    expect(page).to have_content("can't be blank")
  end
end   