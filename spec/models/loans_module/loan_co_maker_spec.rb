require 'rails_helper'

module LoansModule
  describe LoanCoMaker do
    describe 'associations' do 
    	it { is_expected.to belong_to :loan }
    	it { is_expected.to belong_to :co_maker }
    end
  end
end
