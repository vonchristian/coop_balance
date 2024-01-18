require 'rails_helper'

module ManagementModule
  module Settings
    describe CooperativePolicy do
      subject { described_class.new(user, record) }
      let(:record) { create(:cooperative) }

      context 'manager' do
        let(:user) { create(:user, role: 'general_manager') }

        it { should permit_action(:edit) }
        it { should permit_action(:update) }
        it { should_not permit_action(:destroy) }
      end

      context 'accountant' do
        let(:user) { create(:user, role: 'accountant') }

        it { should_not permit_action(:edit) }
        it { should_not permit_action(:update) }
        it { should_not permit_action(:destroy) }
      end
    end
  end
end
