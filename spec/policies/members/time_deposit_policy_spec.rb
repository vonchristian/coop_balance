require 'rails_helper'

module Members
  describe TimeDepositPolicy do
    subject { Members::TimeDepositPolicy.new(user, record) }
    let(:record) { create(:time_deposit) }
    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
  end
end
