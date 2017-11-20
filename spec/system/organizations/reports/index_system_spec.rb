require 'rails_helper'

describe 'Organization reports index' do
  it "with valid attributes" do
    user = create(:user, role: 'loan_officer')
    login_as(user, :scope => :user)
    organization = create(:organization)
    visit organization_reports_url(organization)
    expect(page).to have_content("Reports")
  end
end
