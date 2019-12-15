require 'rails_helper'

describe 'Loan accounting index page' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    @loan      = create(:loan, office: bookkeeper.office)

    login_as(bookkeeper, scope: :user)

    visit loan_path(@loan)
    click_link "#{@loan.id}-accounting"
  end

  it 'with valid attributes', js: true do
    expect(page).to have_content('Accounting Section')

    expect(page).to have_content(@loan.receivable_account_name)
    expect(page).to have_content(@loan.interest_revenue_account_name)
    expect(page).to have_content(@loan.penalty_revenue_account_name)


  end
end
