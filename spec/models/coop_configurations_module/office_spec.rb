require 'rails_helper'

module CoopConfigurationsModule
  describe BranchOffice do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :address }
      it { is_expected.to validate_presence_of :contact_number }
      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
