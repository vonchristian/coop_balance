require 'rails_helper'

module LoansModule
  describe AmortizationSchedule do
    describe 'associations' do
    	it { is_expected.to belong_to :loan }
    end
  end
end
