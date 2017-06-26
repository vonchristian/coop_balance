require 'rails_helper'

describe AmortizationSchedule do
  describe 'associations' do 
  	it { is_expected.to belong_to :loans }
  end
end
