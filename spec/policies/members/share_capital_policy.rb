require 'rails_helper'

module Members
  describe ShareCapitalPolicy do
    subject { Members::ShareCapitalPolicy.new(user, record) }
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
  end
end
