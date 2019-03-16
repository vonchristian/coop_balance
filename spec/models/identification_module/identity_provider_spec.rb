require 'rails_helper'

module IdentificationModule
  describe IdentityProvider do
    describe 'associations' do
      it { is_expected.to have_many :issued_identities }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of   :name }
      it { is_expected.to validate_presence_of   :abbreviated_name }
      it { is_expected.to validate_presence_of   :account_number }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_uniqueness_of :abbreviated_name }
      it { is_expected.to validate_uniqueness_of :account_number }
    end
    
  end
end
