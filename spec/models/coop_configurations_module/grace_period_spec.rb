require 'rails_helper'

module CoopConfigurationsModule
  describe GracePeriod do
    describe 'validations' do
      it { should validate_presence_of :number_of_days }
      it { should validate_numericality_of :number_of_days }
    end
  end
end
