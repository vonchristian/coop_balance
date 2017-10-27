require 'rails_helper'

feature "Add Co maker to loan" do 
	before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    loan = create(:loan)
    visit loans_module_loan_url(loan)
    click_link 'Add Co Maker'
  end

	scenario 'with valid attributes' do 
    member = create(:member)
    click_button "Add"

    expect(page).to have_content 'successfully'
  end
end 