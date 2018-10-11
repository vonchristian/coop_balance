require 'rails_helper'

describe 'Edit member details' do
  before(:each) do
    cooperative = create(:cooperative)
    member = create(:member, last_name: "Hap", first_name: "Von", middle_name: "P")
    member.memberships.create(cooperative: cooperative)
    user = create(:user, role: 'general_manager', cooperative: cooperative)
    login_as(user, scope: :user)

    visit members_url
    save_and_open_page
    click_link "Hap, Von P"
    click_link "Update Profile"
  end

  it 'with valid attributes' do
    fill_in "Last name", with: "Halip"

    click_button "Save Member"

    expect(page).to have_content "Halip"
    expect(page).to_not have_content "Hap"

  end

  it 'with invalid attributes' do
    fill_in "Last name", with: ""

    click_button "Save Member"

    expect(page).to have_content "can't be blank"
  end
end
