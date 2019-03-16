require 'rails_helper'

module IdentificationModule
  describe Identification do
    describe 'associations' do
      it { is_expected.to belong_to :identity_provider }
      it { is_expected.to belong_to :identifiable }
    end
  end
end
