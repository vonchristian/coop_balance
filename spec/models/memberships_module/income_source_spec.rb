require 'rails_helper'

module MembershipsModule
  describe IncomeSource do
    describe 'associations' do 
      it { is_expected.to belong_to :member }
      it { is_expected.to belong_to :income_source_category }
    end 

    describe 'validations' do 
      it { is_expected.to validate_presence_of :designation }
      it { is_expected.to validate_presence_of :description }
    end 
  end
end 
