require 'rails_helper'

module Members
  describe LoanPolicy do
    subject { Members::LoanPolicy.new(user, record) }
    let(:record) { create(:loan) }
    context 'teller' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { is_expected.to permit_action(:new) }
      it { is_expected.to permit_action(:create) }
    end
    context 'manager' do
      let(:user) { create(:user, role: 'manager') }

      it { is_expected.to_not permit_action(:new) }
      it { is_expected.to_not permit_action(:create) }
    end
  end
end
