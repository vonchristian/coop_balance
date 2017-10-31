require 'rails_helper'

describe 'New employee membership' do
  before(:each) do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    @employee = create(:user)
    visit employee_url(@employee)
    cash_on_hand = create(:asset, name: "Cash on Hand (Teller)")
  end

  it 'with valid attributes' do
    click_link 'Update Membership'
    choose "Regular Member"
    click_button "Save Membership"

    expect(page).to have_content("saved successfully")
    expect(@employee.regular_member?).to be true
  end
end
