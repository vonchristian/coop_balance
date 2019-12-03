require 'rails_helper'

include ChosenSelect

describe 'New share capital application' do
  before(:each) do
    teller = create(:teller)
    member = create(:member) { include Addressable }

    membership = create(:membership, cooperator: member, cooperative: teller.cooperative)
    login_as(teller, scope: :user)
    visit members_path
    click_link member.full_name
    click_link "#{member.id}-share_capitals"
    click_link 'New Share Capital'
  end

  it 'with valid attributes' do
    fill_in 'Amount', with: 5_000
    fill_in 'Date', with: Date.current.strftime('%B %e, %Y')
    fill_in 'Reference number', with: '10101'
    select_from_chosen 'Share Capital - Common'

    click_button 'Proceed'

    expect(page).to have_content('created successfully')
  end
end
