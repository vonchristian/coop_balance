require 'rails_helper'

module IdentificationModule
  describe IdentityProvider do
    describe 'associations' do
      it { should have_many :issued_identities }
    end

    describe 'validations' do
      it { should validate_presence_of   :name }
      it { should validate_presence_of   :abbreviated_name }
      it { should validate_presence_of   :account_number }
      it { should validate_uniqueness_of :name }
      it { should validate_uniqueness_of :abbreviated_name }
      it { should validate_uniqueness_of :account_number }
    end
  end
end
