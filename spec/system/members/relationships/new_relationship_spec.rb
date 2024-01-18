require 'rails_helper'

describe 'New relationship' do
  before do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    member = create(:member, last_name: 'Cruz')
    create(:member, last_name: 'Cruz')
    visit member_info_index_path(member)
    click_link 'New Relationship'
  end

  it 'with valid attributes' do
    choose 'father'
    click_button 'Add'
  end
end

