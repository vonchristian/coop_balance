require 'rails_helper'
describe 'Create Organization', type: :system do
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    visit organizations_url
  end

  it "with valid attributes" do
    click_link "New Organization"
    attach_file("uploadOrganizationAvatar", Rails.root + "spec/support/images/default.png")
    fill_in "Name", with: "Women's Organization"
    click_button "Save Organization"

    expect(page).to have_content("saved successfully")
    expect(Organization.count).to eql 1
    expect(Organization.last.avatar).to be_present
  end
end
