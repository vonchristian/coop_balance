require 'rails_helper'

module LoansModule
  module LoanProducts
    describe PenaltyConfig do
      describe 'associations' do
        it { is_expected.to belong_to :loan_product }
     
      end
    end
  end
end
