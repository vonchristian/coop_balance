require 'rails_helper'

describe 'Edit employee membership' do
  before do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    @employee = create(:user)
    create(:membership, membership_type: 'associate_member', memberable: @employee)
    visit employee_url(@employee)
    cash_on_hand = create(:asset, name: 'Cash on Hand (Teller)')
    @employee.cash_on_hand_account = cash_on_hand
  end

  it 'with valid attributes' do
    click_link 'Update Membership'
    choose 'Regular Member'
    click_button 'Save Membership'

    expect(page).to have_content('saved successfully')
    expect(@employee.regular_member?).to be true
  end
end
