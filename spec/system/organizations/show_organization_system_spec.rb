require 'rails_helper'
describe 'Show Organization', type: :system do
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    organization = create(:organization, name: "Women")
    visit organizations_url
    click_link  organization.name
  end

  it "with valid attributes" do


    expect(page).to have_content("Women")
  end
end
