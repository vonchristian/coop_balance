require 'rails_helper'

module LoansModule
  module LoanProducts
    describe LoanProductCharge do
      describe 'associations' do
        it { is_expected.to belong_to :charge }
        it { is_expected.to belong_to :loan_product }
      end

      describe 'delegations' do
        it { is_expected.to delegate_method(:name).to(:charge) }
        it { is_expected.to delegate_method(:amount).to(:charge) }
      end
    end
  end
end
