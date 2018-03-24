require 'rails_helper'

feature 'New relationship' do
  before(:each) do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user )
    member = create(:member, last_name: "Cruz")
    another_member = create(:member, last_name: "Cruz")
    visit member_info_index_path(member)
    click_link "New Relationship"
  end
  scenario 'with valid attributes' do
    choose 'father'
    click_button "Add"
  end
end

