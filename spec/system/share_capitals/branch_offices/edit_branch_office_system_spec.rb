require 'rails_helper'

describe 'Update branch office' do
  it 'with valid attributes' do
    user = create(:user, role: 'manager')
    login_as(user, :scope => :user)
    share_capital = create(:share_capital)
    branch_office = create(:branch_office, branch_name: "Mansoyosoy Branch")
    visit share_capitals_url
    click_link share_capital.subscriber_name.upcase
    click_link 'Update Branch Office'

    choose "Mansoyosoy Branch"

    click_button "Update Branch Office"

    expect(page).to have_content('updated successfully')
  end
end
