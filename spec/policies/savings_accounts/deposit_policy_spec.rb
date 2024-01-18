require 'rails_helper'

module SavingsAccounts
  describe DepositPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:saving) }

    context 'manager' do
      let(:user) { create(:user, role: 'general_manager') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end

    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'treasurer' do
      let(:user) { create(:user, role: 'treasurer') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end
  end
end
