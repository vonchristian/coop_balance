require 'rails_helper'

module CoopServicesModule
  describe CooperativeService do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
    end
  end
end
