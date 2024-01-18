require 'rails_helper'
include ChosenSelect

describe 'New membership application' do
  before do
    user                = create(:user, role: 'teller')
    province            = create(:province, name: 'Test province')
    municipality        = create(:municipality, name: 'Test municipality', province: province)
    create(:barangay, name: 'Test barangay', municipality: municipality)
    cooperative = user.cooperative
    create(:membership_category, cooperative: cooperative, title: 'Regular Member')
    user.office

    login_as(user, scope: :user)
    visit members_path
    find(:css, 'i.fa.fa-user-plus').click
  end

  it 'with valid attributes', :js do
    select_from_chosen 'Regular Member',    from: 'Membership category'
    fill_in 'First name',                   with: 'Von'
    fill_in 'Middle name',                  with: 'P'
    fill_in 'Last name',                    with: 'Halip'
    choose 'Male'
    choose 'Married'
    fill_in 'Date of birth',                with: '02/12/1990'
    fill_in 'Contact number',               with: '48234239482934'
    fill_in 'Email',                        with: 'ddd@example.com'
    fill_in 'TIN Number',                   with: '2342424'
    fill_in 'Complete address',             with: 'dasjd aksdaj skda'
    page.execute_script 'window.scrollBy(0,10000)'
    select_from_chosen 'Test province',     from: 'Province'
    select_from_chosen 'Test municipality', from: 'Municipality'
    select_from_chosen 'Test barangay',     from: 'Barangay'
    fill_in 'Membership date',              with: Date.current

    click_button 'Save Member'

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes', :js do
    click_button 'Save Member'

    expect(page).to have_content("can't be blank")
  end
end
