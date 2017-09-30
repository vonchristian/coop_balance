require 'rails_helper'

feature "Add occupation of member" do 
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
   
  end

  scenario 'with valid attributes' do 
     member = create(:member)
    visit member_url(member)

    click_link 'Add Occupation'
    fill_in "Title", with: "Farming"
    click_button "Add Occupation"
    expect(page).to have_content("added successfully")
  end 

  scenario 'with invalid attributes' do 
     member = create(:member)
    visit member_url(member)

    click_link 'Add Occupation'
    click_button 'Add Occupation'

    expect(page).to have_content("can't be blank")
  end
end 