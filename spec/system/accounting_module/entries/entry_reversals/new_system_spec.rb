require 'rails_helper'

describe 'New entry reversal' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    @entry     = build(:entry, office: bookkeeper.office)
    @cash      = create(:asset)
    @revenue   = create(:revenue)
    @entry.debit_amounts.build(amount: 100, account: @cash)
    @entry.credit_amounts.build(amount: 100, account: @revenue)
    @entry.save!
    login_as(bookkeeper, scope: :user)
    visit accounting_module_entry_path(@entry)
    click_button 'Options'
    click_link 'Reverse Entry'
  end

  it 'with valid attributes' do
    fill_in 'Description', with: 'wrong entry'

    click_button 'Reverse Entry'

    expect(page).to have_content('created successfully')

    click_link 'Confirm Transaction'

    expect(page).to have_content('saved successfully')

  end

end
