require 'rails_helper'
module LoansModule
  describe Loan do
    context 'associations' do 
    	it { is_expected.to belong_to :member }
    	it { is_expected.to belong_to :loan_product }
    	it { is_expected.to have_many :loan_approvals }
    	it { is_expected.to have_many :approvers }
    	it { is_expected.to have_many :entries }
    end 

    context 'delegations' do 
    	it { is_expected.to delegate_method(:full_name).to(:member).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:loan_product).with_prefix }
    end
  end
end
