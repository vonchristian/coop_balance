require 'rails_helper'

module ManagementModule 
  module Settings
    describe CooperativePolicy do
      subject { ManagementModule::Settings::CooperativePolicy.new(user, record) }
      let(:record) { create(:cooperative) }
      context 'manager' do
        let(:user) { create(:user, role: 'manager') }

        it { is_expected.to permit_action(:edit)}
        it { is_expected.to permit_action(:update)}
        it { is_expected.to_not permit_action(:destroy)}
      end
      context 'accountant' do
        let(:user) { create(:user, role: 'accountant') }

        it { is_expected.to_not permit_action(:edit)}
        it { is_expected.to_not permit_action(:update)}
        it { is_expected.to_not permit_action(:destroy)}
      end
    end
  end
end
