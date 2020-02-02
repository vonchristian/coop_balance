require 'rails_helper'

describe 'Time deposits index page' do
  it 'valid' do
    teller       = create(:teller)
    depositor    = create(:member)
    time_deposit = create(:time_deposit, depositor: depositor, cooperative: teller.cooperative, office: teller.office)
    login_as(teller, scope: :user)

    visit time_deposits_path
    save_and_open_page
    expect(page).to have_content(depositor.full_name.upcase)
    expect(page).to have_content(time_deposit.balance)

    
  end
end
