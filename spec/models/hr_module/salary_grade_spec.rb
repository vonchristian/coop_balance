require 'rails_helper'

module HrModule
  describe SalaryGrade do
    describe 'associations' do
      it { is_expected.to have_many :employees }
    end
  end
end
