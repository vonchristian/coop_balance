require 'rails_helper'

module TimeDeposits
  describe BreakContractPolicy do
    subject { TimeDeposits::BreakContractPolicy.new(user, record) }
    let(:record) { create(:time_deposit) }
    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
    context 'teller' do
      let(:user) { create(:user, role: 'treasurer') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
  end
end
