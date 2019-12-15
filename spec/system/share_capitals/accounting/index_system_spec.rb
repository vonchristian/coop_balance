require 'rails_helper'

describe 'Share capital accounting index page' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    @share_capital = create(:share_capital, office: bookkeeper.office)
    login_as(bookkeeper, scope: :user)

    visit share_capital_path(@share_capital)
    click_link "#{@share_capital.id}-accounting"
  end

  it 'with valid attributes', js: true do
    expect(page).to have_content('Accounting Section')
    expect(page).to have_content(@share_capital.share_capital_equity_account_name)
  end
end
