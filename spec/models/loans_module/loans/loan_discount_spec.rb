require 'rails_helper'

module LoansModule
  module Loans
    describe LoanDiscount do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :discountable }
        it { is_expected.to belong_to :employee }
      end

      it '.total' do
        discount_1 = create(:loan_discount, amount: 100)
        discount_2 = create(:loan_discount, amount: 200)

        expect(described_class.total).to eql 300
      end
    end
  end
end
