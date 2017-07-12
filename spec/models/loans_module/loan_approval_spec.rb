require 'rails_helper'

module LoansModule
  describe LoanApproval do
    context 'associations' do 
    	it { is_expected.to belong_to :approver }
    	it { is_expected.to belong_to :loan }
    end 
  end 
end
