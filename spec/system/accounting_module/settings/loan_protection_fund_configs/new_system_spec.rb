require 'rails_helper'

describe 'New Loan protection fund config' do
  before do
    user = create(:user, role: 'accountant')
    login_as(user, scope: :user)
    create(:asset, name: 'Accounts Receivable - General Merchandise')
    visit accounting_module_settings_url
    click_link 'Set Loan Protection Fund Account'
  end

  it 'with valid attributes' do
    select 'Accounts Receivable - General Merchandise'
    click_button 'Save'

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button 'Save'

    expect(page).to have_content("can't be blank")
  end
end
