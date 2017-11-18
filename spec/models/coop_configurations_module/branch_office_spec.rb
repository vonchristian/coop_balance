require 'rails_helper'

module CoopConfigurationsModule
  describe BranchOffice do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :sections }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :branch_name }
      it { is_expected.to validate_presence_of :address }
      it { is_expected.to validate_presence_of :contact_number }
      it { is_expected.to validate_uniqueness_of :branch_name }
    end
  end
end
