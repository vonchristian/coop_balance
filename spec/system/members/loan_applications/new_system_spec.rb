require 'rails_helper'
include ChosenSelect

describe "New loan application", type: :system do
  before(:each) do
    cash              = create(:asset, name: 'Cash on Hand')
    teller            = create(:teller)
    teller.cash_accounts << cash
    amortization_type = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_principal')
    loan_product      = create(:loan_product, name: "Regular Loan", amortization_type: amortization_type)
    user              = create(:loan_officer)
    member            = create(:member)
    member.memberships.create!(cooperative: user.cooperative, membership_type: 'regular_member', account_number: SecureRandom.uuid, office: teller.office, membership_date: Date.current)
    login_as(user, scope: :user)
    visit member_loans_path(member)
    click_link 'New Loan Application'
  end

  it 'with valid attributes', js: true do
    fill_in 'Application date', with: Date.current.strftime('%B %e, %Y')
    select_from_chosen "Regular Loan", from: 'Select Type of Loan'
    fill_in "Loan amount", with: 10_000
    fill_in "Term (Number of days)", with: 60
    page.execute_script "window.scrollBy(0,10000)"

    choose "Lumpsum"
    page.execute_script "window.scrollBy(0,10000)"

    fill_in "Purpose of Loan", with: 'YEB'

    click_button 'Proceed'

    expect(page).to have_content("saved successfully")

    fill_in 'Date', with: Date.current
    page.execute_script "window.scrollBy(0,10000)"

    select 'Cash on Hand', from: 'Cash account'
    fill_in 'Reference number', with: '232'
    click_button 'Create Voucher'

    expect(page).to have_content("saved successfully")

  end

  it 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
