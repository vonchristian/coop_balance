require 'rails_helper'

describe 'Edit member membership' do
  before(:each) do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    member = create(:associate_member)
    visit member_url(member)
  end

  it 'with valid attributes' do
    click_link 'Update Membership'
    choose "Regular Member"
    click_button "Save Membership"

    expect(page).to have_content("saved successfully")
  end
end
