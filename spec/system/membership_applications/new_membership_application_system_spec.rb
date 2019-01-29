require 'rails_helper'

describe "New membership application" do
  before(:each) do
    barangay = create(:barangay, name: "Test barangay")
    municipality = create(:municipality, name: "Test municipality")
    province = create(:province, name: "Test province")
    cooperative = create(:cooperative)
    office = create(:office, cooperative: cooperative)
    user = create(:user, role: 'teller', cooperative: cooperative, office: office)
    login_as(user, scope: :user)
    visit members_url
    click_link "New Member"
  end

  it "wtih valid attributes" do
    choose "Regular Member"
    fill_in "First name", with: "Von"
    fill_in "Middle name", with: "P"
    fill_in "Last name", with: "Halip"
    choose "Male"
    choose "Married"
    fill_in "Date of birth", with: "02/12/1990"
    fill_in "Contact number", with: "48234239482934"
    fill_in "Email", with: 'ddd@example.com'
    fill_in "TIN Number", with: "2342424"
    fill_in "Membership date", with: Date.current
    fill_in "Complete address", with: "dasjd aksdaj skda"
    select "Test barangay"
    select "Test municipality"
    select "Test province"
    click_button "Save Member"

    expect(page).to have_content("saved successfully")
  end
end
