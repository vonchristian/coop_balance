require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
      it { is_expected.to have_many :payment_notices }
    	it { is_expected.to belong_to :loan }
      it { is_expected.to have_many :notes }
    end
  end
end
