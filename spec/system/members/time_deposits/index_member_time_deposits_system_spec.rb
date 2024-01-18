require 'rails_helper'

describe 'Index of member time deposits' do
  it 'logged in' do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    member = create(:regular_member)
    visit member_time_deposits_url(member)
    expect(page).to have_content('Time Deposits')
  end
end
