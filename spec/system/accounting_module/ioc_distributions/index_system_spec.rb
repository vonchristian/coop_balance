require 'rails_helper'

describe 'IOC Distribution index page' do
  it 'with logged in user', :js do
    bookkeeper = create(:bookkeeper)
    login_as(bookkeeper, scope: :user)

    visit accounting_module_ioc_distributions_path

    expect(page).to have_content('Loans')
  end
end