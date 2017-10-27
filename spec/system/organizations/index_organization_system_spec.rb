require 'rails_helper'

describe 'Index Organization', type: :system do
  before(:each) do
    user = create(:user)
    login_as(user, :scope => :user)
    organization = create(:organization, name: "Women's Organization")
    visit organizations_url
  end

  it "lists organizations" do
    expect(page).to have_content("Women's Organization")
  end
end
