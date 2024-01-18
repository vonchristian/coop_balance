require 'rails_helper'

describe 'Savings accounting index page' do
  it 'with valid attributes' do
    bookkeeper     = create(:bookkeeper)
    @saving        = create(:saving, office: bookkeeper.office)
    login_as(bookkeeper, scope: :user)

    visit savings_account_path(@saving)
    click_link "#{@saving.id}-accounting"

    expect(page).to have_content('Accounting Section')
    expect(page).to have_content(@saving.liability_account_name)
    expect(page).to have_content(@saving.interest_expense_account_name)
  end
end
