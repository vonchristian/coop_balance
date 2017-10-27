require 'rails_helper'

feature "Create voucher" do 
  before(:each) do
    user = create(:loan_officer)
    login_as(user, :scope => :user)
    loan = build(:loan)
    visit loan_url(loan)
    click_link 'Create Voucher' 
  end

  scenario 'with valid attributes' do 
  end
end
