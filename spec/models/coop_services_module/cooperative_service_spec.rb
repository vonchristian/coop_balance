require 'rails_helper'

module CoopServicesModule
  describe CooperativeService do
    describe 'associations' do
      it { should belong_to :cooperative }
      it { should have_many :accountable_accounts }
      it { should have_many :accounts }
    end
  end
end
