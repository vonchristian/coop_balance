require 'rails_helper'

feature 'Create Property' do
	before(:each) do 
    user = create(:user, role: 'loan_officer')
    login_as(user, :scope => :user)
    member = create(:member)
    visit loans_module_member_path(member)
    click_link 'New Property'
  end

  scenario 'with valid attributes' do 

  end 
end 