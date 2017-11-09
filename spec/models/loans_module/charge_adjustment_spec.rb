require 'rails_helper'

module LoansModule
  describe ChargeAdjustment do
    describe 'associations' do
      it { is_expected.to belong_to :loan_charge }
    end
    describe 'validations' do
    end
  end
end
