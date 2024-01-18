require 'rails_helper'

module LoansModule
  module AmortizationConfigs
    describe InterestAmortization do
      describe 'validations' do
        it { should validate_presence_of :calculation_type }
      end

      describe 'enums' do
        it { should define_enum_for(:calculation_type).with_values(%i[straight_line declining_balance]) }
      end

      describe 'interest_amortizer' do
        it 'straight_line' do
          straight_line = create(:interest_amortization, calculation_type: 'straight_line')

          expect(straight_line.interest_amortizer).to eql LoansModule::InterestAmortizers::StraightLine
        end

        it 'declining_balance' do
          declining_balance = create(:interest_amortization, calculation_type: 'declining_balance')

          expect(declining_balance.interest_amortizer).to eql LoansModule::InterestAmortizers::DecliningBalance
        end
      end
    end
  end
end
