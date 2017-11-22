require 'rails_helper'

module CoopConfigurationsModule
  describe Section do
    describe 'associations' do
      it { is_expected.to belong_to :branch_office }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
