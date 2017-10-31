require 'rails_helper'

describe 'Index of employee time deposits' do
  it "logged in" do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user )
    employee = create(:employee, role: 'manager')
    visit employee_time_deposits_url(employee)
    expect(page).to have_content("Time Deposits")
  end
end
