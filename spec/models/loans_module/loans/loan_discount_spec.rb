require 'rails_helper'

module LoansModule
  module Loans
    describe LoanDiscount do
      describe 'associations' do
        it { should belong_to :loan }
      end

      it { should define_enum_for(:discount_type).with_values(%i[interest penalty]) }

      it '.total' do
        create(:loan_discount, amount: 100)
        create(:loan_discount, amount: 200)

        expect(described_class.total).to be 300
      end
    end
  end
end
