require 'rails_helper'

module LoansModule
  describe LoanCharge do
    describe 'associations' do 
    	it { is_expected.to belong_to :loan }
    	it { is_expected.to belong_to :charge }
    end
  end 
end
