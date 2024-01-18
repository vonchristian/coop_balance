require 'rails_helper'

describe 'Member settings index page' do
  it 'with valid attributes' do
    member  = create(:member)
    manager = create(:general_manager)
    create(:membership, cooperator: member, cooperative: manager.cooperative)
    login_as(manager, scope: :user)
    visit member_path(member)
    click_link "#{member.id}-settings"

    expect(page).to have_content 'Member Settings'
  end
end