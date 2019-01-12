require 'rails_helper'

module LoansModule
  describe AmortizationType do
    describe 'validations' do
      it { is_expected.to validate_presence_of :calculation_type }
    end
    describe 'enums' do
      it { is_expected.to define_enum_for(:calculation_type).with_values([:straight_line, :declining_balance]) }
    end
  end
end
