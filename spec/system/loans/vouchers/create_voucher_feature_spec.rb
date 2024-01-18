require 'rails_helper'

describe 'Create voucher' do
  before do
    user = create(:loan_officer)
    login_as(user, scope: :user)
    loan = build(:loan)
    visit loan_url(loan)
    click_link 'Create Voucher'
  end

  it 'with valid attributes' do
  end
end
