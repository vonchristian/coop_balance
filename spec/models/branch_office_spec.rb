require 'rails_helper'

RSpec.describe BranchOffice, type: :model do
  describe 'associations' do 
    it { is_expected.to belong_to :cooperative }
  end
  
  describe 'validations' do 
    it { is_expected.to validate_presence_of :branch_name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :contact_number }
    it { is_expected.to validate_uniqueness_of :branch_name }
  end

end
