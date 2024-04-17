require 'rails_helper'

module CoopServicesModule
  describe CooperativeService do
    describe 'associations' do
      it { should belong_to :cooperative }
    end
  end
end
