require 'rails_helper'

describe 'New program subscription' do
  before(:each) do
    teller = create(:teller)
    member = create(:member)
    member.memberships.create!(office: teller.office, cooperative: teller.cooperative, account_number: SecureRandom.uuid)
    login_as(teller, scope: :user)
    visit members_path
    click_link member.full_name
    click_link "#{member.id}-subscriptions"
    click_link 'New Subscription'
  end

  it 'with valid attributes' do
  end
end
