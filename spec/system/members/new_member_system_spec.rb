require 'rails_helper'

describe "New Member" do
  before :each do
    cooperative = create(:cooperative)
    user = create(:user, role: 'teller', cooperative: cooperative)
    login_as(user, scope: :user )
    visit members_url
    click_link "New Member"
  end

  it "with valid attributes" do
    choose 'Regular Member'
    fill_in "First name", with: "Von"
    fill_in "Middle name", with: "Pinosan"
    fill_in "Last name", with: "Halip"
    choose "Male"
    choose "Married"
    fill_in "Date of birth", with: '12/02/1990'
    fill_in "TIN Number", with: '331231123'
    click_button "Save Member"

    expect(page).to have_content "saved successfully"
  end

  it "with invalid attributes" do
  end
end
