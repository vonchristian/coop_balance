require 'rails_helper'

describe 'New member registration' do
  before do
    user = create(:user, role: 'general_manager')
    login_as(user, scope: :user)
    visit members_url
    click_link 'New Member'
  end

  it 'with valid attributes' do
    choose 'Regular Member'
    fill_in 'First name', with: 'Von Christian'
    fill_in 'Middle name', with: 'Pinosan'
    fill_in 'Last name', with: 'Halip'
    choose 'Married'
    choose 'Male'
    fill_in 'Date of birth', with: '02/12/1990'
    fill_in 'Contact number', with: '09124567890'
    fill_in 'Email', with: 'test@email.com'
    fill_in 'TIN Number', with: '2140553-332'

    click_button 'Save Membership Application'

    expect(page).to have_content 'saved successfully'
    expect(page).to have_content 'Halip'
  end

  it 'with invalid attributes' do
    click_button 'Save Membership Application'

    expect(page).to have_content "can't be blank"
  end
end
