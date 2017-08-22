require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do 
    	it { is_expected.to have_many :loans }
    	it { is_expected.to have_many :loan_product_charges }
    	it { is_expected.to have_many :charges }

    end
  end
end
