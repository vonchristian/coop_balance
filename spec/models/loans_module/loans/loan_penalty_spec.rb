require 'rails_helper'

module LoansModule
  module Loans
    describe LoanPenalty do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
      end
    end
  end
end
