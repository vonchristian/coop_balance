require 'rails_helper'

module ShareCapitals
  describe BalanceTransferPolicy do
    subject { described_class.new(user, record) }
    let(:record) { create(:share_capital) }

    context 'manager' do
      let(:user) { create(:user, role: 'general_manager') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end

    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end

    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { should_not permit_action(:new) }
      it { should_not permit_action(:create) }
    end

    context 'bookkeeper' do
      let(:user) { create(:user, role: 'bookkeeper') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end

    context 'accountant' do
      let(:user) { create(:user, role: 'accountant') }

      it { should permit_action(:new) }
      it { should permit_action(:create) }
    end
  end
end
