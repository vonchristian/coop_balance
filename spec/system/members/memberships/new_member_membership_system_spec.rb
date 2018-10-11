require 'rails_helper'

describe 'New member membership' do
  before(:each) do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    member = create(:member)
    visit member_url(member)
  end

  it 'with valid attributes' do
    click_link 'Update Membership'
    choose "Regular Member"
    click_button "Save Membership"

    expect(page).to have_content("saved successfully")
    expect(@member.regular_member?).to be true
  end
end
