require 'rails_helper'

module LoansModule
  module Loans
    describe LoanDiscount do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :computed_by }
      end
    end
  end
end
