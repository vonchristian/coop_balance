require 'rails_helper'

module LoansModule
  module AmortizationConfigs
    describe TotalRepaymentAmortization do
      describe 'validations' do
        it { should validate_presence_of :calculation_type }
      end

      describe 'enums' do
        it { should define_enum_for(:calculation_type).with_values(%i[equal_principal equal_payment]) }
      end

      describe '#total_repayment_amortizer' do
        it 'equal_principal' do
          equal_principal = create(:total_repayment_amortization, calculation_type: 'equal_principal')

          expect(equal_principal.total_repayment_amortizer).to eql LoansModule::TotalRepaymentAmortizers::EqualPrincipal
        end

        it 'equal_payment' do
          equal_payment = create(:total_repayment_amortization, calculation_type: 'equal_payment')

          expect(equal_payment.total_repayment_amortizer).to eql LoansModule::TotalRepaymentAmortizers::EqualPayment
        end
      end
    end
  end
end
