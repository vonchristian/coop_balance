require 'rails_helper'

module CoopServicesModule
  describe SavingProduct do
    context "associations" do 
    	it { is_expected.to have_many :subscribers }
    end 
    context "validations" do 
    	it { is_expected.to validate_presence_of :interest_recurrence }
    	it { is_expected.to validate_presence_of :interest_rate }
    	it do 
    		is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
    	end
    	it { is_expected.to validate_presence_of :name }
    	it { is_expected.to validate_uniqueness_of :name }

    end

    it { is_expected.to define_enum_for(:interest_recurrence).with([:daily, :weekly, :monthly, :quarterly, :annually]) }
  end
end
