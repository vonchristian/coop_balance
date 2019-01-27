require 'rails_helper'

module LoansModule
  describe AmortizationType do
    describe 'validations' do
      it { is_expected.to validate_presence_of :calculation_type }
      it { is_expected.to validate_presence_of :repayment_calculation_type }

    end
    describe 'enums' do
      it { is_expected.to define_enum_for(:calculation_type).with_values([:straight_line, :declining_balance]) }
      it { is_expected.to define_enum_for(:repayment_calculation_type).with_values([:equal_principal, :equal_payment]) }
    end
    describe 'amortizer' do

      it 'returns straight_line' do
        straight_line = create(:straight_line_amortization_type)

        expect(straight_line.amortizer).to eql LoansModule::Amortizers::StraightLine
      end

      it 'returns declining_balance' do
        declining_balance = create(:declining_balance_amortization_type)

        expect(declining_balance.amortizer).to eql LoansModule::Amortizers::DecliningBalance

      end
    end

    describe 'amortizeable_principal_calculator' do
      it 'returns straight_line' do
        equal_payment = create(:equal_payment_amortization_type)

        expect(equal_payment.amortizeable_principal_calculator).to eql LoansModule::Amortizers::PrincipalCalculators::EqualPayment
      end

      it 'returns declining_balance' do
        declining_balance = create(:equal_principal_amortization_type)

        expect(declining_balance.amortizeable_principal_calculator).to eql LoansModule::Amortizers::PrincipalCalculators::EqualPrincipal
      end
    end
  end
end
