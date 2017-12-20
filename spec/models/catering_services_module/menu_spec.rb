require 'rails_helper'

module CateringServicesModule
  describe Menu do
    describe 'associations' do
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
    end
  end
end
