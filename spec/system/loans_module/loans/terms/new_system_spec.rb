require 'rails_helper'

describe 'New loan term' do
  before(:each) do
    loan_officer = create(:loan_officer)
    loan         = create(:loan, office: loan_officer.office, cooperative: loan_officer.cooperative)
    login_as(loan_officer, scope: :user)
    visit loan_path(loan)
    click_link "#{loan.id}-settings"
    click_link 'New Term'
  end

  it 'with valid attributes' do
    fill_in 'Term (Number of days)', with: 30
    fill_in 'Effectivity date', with: Date.current.strftime('%B %e, %Y')


    click_button 'Save Term'

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do

    click_button 'Save Term'

    expect(page).to have_content("can't be blank")
  end 
end
