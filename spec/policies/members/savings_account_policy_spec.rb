require 'rails_helper'

module Members
  describe SavingsAccountPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:saving) }

    context 'manager' do
      let(:user) { create(:user, role: 'manager') }

      it { should_not permit_action(:edit) }
      it { should_not permit_action(:update) }
      it { should permit_action(:destroy) }
    end

    context 'accountant' do
      let(:user) { create(:user, role: 'accountant') }

      it { should_not permit_action(:edit) }
      it { should_not permit_action(:update) }
      it { should_not permit_action(:destroy) }
    end
  end
end
