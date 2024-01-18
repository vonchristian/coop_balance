require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestPrededuction do
      describe 'associations' do
        it { should belong_to :loan_product }
      end

      describe 'validations' do
        it { should validate_presence_of :calculation_type }
        it { should validate_numericality_of :amount }
        it { should validate_numericality_of :rate }
        it { should validate_numericality_of :number_of_payments }
      end

      it { should define_enum_for(:calculation_type).with_values(%i[percent_based amount_based number_of_payments_based]) }

      describe 'calculator' do
        it 'returns percent_based_calculator for percent_based' do
          percent_based = create(:interest_prededuction, calculation_type: 'percent_based')

          expect(percent_based.calculator).to eq LoansModule::InterestPredeductionCalculators::PercentBased
        end

        it 'returns number_of_payments_calculator for number_of_payments' do
          percent_based = create(:interest_prededuction, calculation_type: 'number_of_payments_based')

          expect(percent_based.calculator).to eq LoansModule::InterestPredeductionCalculators::NumberOfPaymentsBased
        end

        it 'returns number_of_payments_calculator for number_of_payments' do
          percent_based = create(:interest_prededuction, calculation_type: 'amount_based')

          expect(percent_based.calculator).to eq LoansModule::InterestPredeductionCalculators::AmountBased
        end
      end
    end
  end
end
