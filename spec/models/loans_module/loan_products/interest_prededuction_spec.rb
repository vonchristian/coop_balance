require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestPrededuction do
      describe 'associations' do
        it { is_expected.to belong_to :loan_product }
      end

      describe 'validations' do
        it { is_expected.to validate_presence_of :calculation_type }
        it { is_expected.to validate_numericality_of :amount }
        it { is_expected.to validate_numericality_of :rate }
        it { is_expected.to validate_numericality_of :number_of_payments }
      end

      it { is_expected.to define_enum_for(:calculation_type).with_values([:percent_based, :amount_based, :number_of_payments]) }
      

    end
  end
end
