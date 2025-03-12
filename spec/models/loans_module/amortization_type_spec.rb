require 'rails_helper'

module LoansModule
  describe AmortizationType do
    describe 'validations' do
      it { should validate_presence_of :calculation_type }
      it { should validate_presence_of :repayment_calculation_type }
    end

    describe 'enums' do
      it { should define_enum_for(:calculation_type).with_values(%i[straight_line declining_balance ipsmpc_amortizer]) }
      it { should define_enum_for(:repayment_calculation_type).with_values(%i[equal_principal equal_payment]) }
      it { should define_enum_for(:interest_amortization_scope).with_values([ :exclude_on_first_year ]) }
    end

    describe 'amortizer' do
      it 'returns straight_lines && equal_principal' do
        straight_line = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_principal')

        expect(straight_line.amortizer).to eql LoansModule::Amortizers::StraightLines::EqualPrincipal
      end

      it 'returns straight_lines && equal_payment' do
        straight_line = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_payment')

        expect(straight_line.amortizer).to eql LoansModule::Amortizers::StraightLines::EqualPayment
      end

      it 'returns declining_balance && equal_principal' do
        declining_balance = create(:declining_balance_amortization_type, repayment_calculation_type: 'equal_principal')

        expect(declining_balance.amortizer).to eql LoansModule::Amortizers::DecliningBalances::EqualPrincipal
      end

      it 'returns declining_balance && equal_payment' do
        declining_balance = create(:declining_balance_amortization_type, repayment_calculation_type: 'equal_payment')

        expect(declining_balance.amortizer).to eql LoansModule::Amortizers::DecliningBalances::EqualPayment
      end
    end

    describe 'amortizeable_principal_calculator' do
      it 'equal_payment' do
        equal_payment = create(:equal_payment_amortization_type)

        expect(equal_payment.amortizeable_principal_calculator).to eql LoansModule::Amortizers::PrincipalCalculators::EqualPayment
      end

      it 'equal_principal' do
        declining_balance = create(:equal_principal_amortization_type)

        expect(declining_balance.amortizeable_principal_calculator).to eql LoansModule::Amortizers::PrincipalCalculators::EqualPrincipal
      end
    end
  end
end
