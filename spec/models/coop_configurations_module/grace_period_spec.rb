require 'rails_helper'

module CoopConfigurationsModule
	describe GracePeriod do
	  describe 'validations' do 
	  	it { is_expected.to validate_presence_of :number_of_days }
	  	it { is_expected.to validate_numericality_of :number_of_days }
	  end
	end
end