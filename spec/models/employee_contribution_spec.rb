require 'rails_helper'

describe EmployeeContribution do
  describe 'associations' do 
    it { is_expected.to belong_to :employee }
    it { is_expected.to belong_to :contribution }
  end
end
