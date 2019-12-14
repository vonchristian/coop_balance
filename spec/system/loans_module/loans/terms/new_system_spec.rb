require 'rails_helper'

describe 'New loan term' do
  before(:each) do
    loan_officer  = create(:loan_officer)
    @loan         = create(:loan, office: loan_officer.office, cooperative: loan_officer.cooperative, term_id: nil)
    binding.pry
    login_as(loan_officer, scope: :user)
    visit loan_path(@loan)
    click_link "#{@loan.id}-settings"
    click_link 'New Term'
  end

  it 'with valid attributes' do
    fill_in 'Term (Number of days)', with: 120
    fill_in 'Effectivity date',      with: Date.current.strftime('%B %e, %Y')

    click_button 'Save Term'

    expect(page).to have_content('saved successfully')

    puts @loan.term.inspect
  end

  it 'with invalid attributes' do

    click_button 'Save Term'

    expect(page).to have_content("can't be blank")
  end

  it 'number of days greater than 0' do
    fill_in 'Term (Number of days)', with: 0
    click_button 'Save Term'

    expect(page).to have_content("must be greater than 0")
  end
end
