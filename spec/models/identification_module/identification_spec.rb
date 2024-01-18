require 'rails_helper'

module IdentificationModule
  describe Identification do
    describe 'associations' do
      it { should belong_to :identity_provider }
      it { should belong_to :identifiable }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:identity_provider).with_prefix }
    end
  end
end
