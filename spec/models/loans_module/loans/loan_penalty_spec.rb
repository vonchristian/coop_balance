require 'rails_helper'

module LoansModule
  module Loans
    describe LoanPenalty do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :computed_by }
        it { is_expected.to have_many :loan_discounts }
      end
    end
  end
end
