require 'rails_helper'

describe 'Time deposits index page' do
  it 'valid' do
    teller       = create(:teller)
    depositor    = create(:member)
    time_deposit = create(:time_deposit, depositor: depositor, cooperative: teller.cooperative)
    login_as(teller, scope: :user)

    visit time_deposits_path

    expect(page).to have_content(depositor.full_name.upcase)
    expect(page).to have_content(time_deposit.amount_deposited)

    expect(page).to have_content(time_deposit.term_effectivity_date.strftime("%B %e, %Y"))
    expect(page).to have_content(time_deposit.term_maturity_date.strftime("%B %e, %Y"))

  end
end
