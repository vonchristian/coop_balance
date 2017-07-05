require 'rails_helper'
module LoansDepartment
  describe Loan do
    describe 'associations' do 
    	it { is_expected.to belong_to :member }
    	it { is_expected.to belong_to :loan_product }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    end 
  end
end
