require 'rails_helper'

describe 'New share capital balance transfer' do
  before do
    bookkeeper       = create(:bookkeeper)
    cash             = create(:asset)
    office           = bookkeeper.office
    @share_capital   = create(:share_capital, office: office)

    cap_1 = build(:entry)
    cap_1.debit_amounts.build(account: cash, amount: 10_000)
    cap_1.credit_amounts.build(account: @share_capital.share_capital_equity_account, amount: 10_000)
    cap_1.save!

    @share_capital_2 = create(:share_capital, office: office)
    cap_2 = build(:entry)
    cap_2.debit_amounts.build(account: cash, amount: 10_000)
    cap_2.credit_amounts.build(account: @share_capital_2.share_capital_equity_account, amount: 10_000)
    cap_2.save!

    login_as(bookkeeper, scope: :user)
    visit share_capital_path(@share_capital)
    click_link "#{@share_capital.id}-accounting"
    click_link 'Balance Transfer'
    click_link "#{@share_capital_2.id}-select-destination-account"
  end

  it 'with valid attributes', :js do
    fill_in 'Amount', with: 100

    click_button 'Proceed'

    expect(page).to have_content('created successfully')

    fill_in 'Reference number', with: '01'
    fill_in 'Description', with: 'test'

    click_button 'Proceed'

    expect(page).to have_content('created successfully')

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end

  it 'with blank attributes' do
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end
end
