require 'rails_helper'
describe 'Organization index', type: :system do
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    visit organizations_url
  end

  it "with valid attributes" do
    click_link "New Organization"
    fill_in "Name", with: "Women's Organization"
    click_button "Save Organization"

    expect(page).to have_content("saved successfully")
  end
end
