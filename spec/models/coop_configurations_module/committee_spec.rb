require 'rails_helper'

module CoopConfigurationsModule
  describe Committee do
    context 'associations' do 
    	it { is_expected.to have_many :committee_members }
    end 

    context 'validations' do 
    	it { is_expected.to validate_uniqueness_of :name }
    	it { is_expected.to validate_presence_of :name }
    end
  end 
end
