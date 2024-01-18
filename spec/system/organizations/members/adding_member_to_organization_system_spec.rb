require 'rails_helper'

describe 'Add member to organization', type: :system do
  it 'with valid attributes' do
    user = create(:user)
    login_as(user, scope: :user)
    @organization = create(:organization, name: 'Women')
    visit organizations_url
    click_link @organization.name
    member = create(:member)
    click_link 'Add Members'
    expect(page).to have_content(member.name)

    click_button('Add Member', match: :first)
    expect(@organization.members).to include(member)
  end
end

