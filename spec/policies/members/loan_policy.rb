require 'rails_helper'

module Members
  describe LoanPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:loan) }

    context 'teller' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'manager' do
      let(:user) { create(:user, role: 'manager') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end
  end
end
