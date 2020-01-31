require 'rails_helper'

module LoansModule
  module Loans
    describe LoanDiscount do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
      end

      it { is_expected.to define_enum_for(:discount_type).with_values([:interest, :penalty]) }

      it '.total' do
        discount_1 = create(:loan_discount, amount: 100)
        discount_2 = create(:loan_discount, amount: 200)

        expect(described_class.total).to eql 300
      end
    end
  end
end
