require 'rails_helper'

module ShareCapitals
  describe BalanceTransferPolicy do
    subject { ShareCapitals::BalanceTransferPolicy.new(user, record) }
    let(:record) { create(:share_capital) }
    context 'manager' do
      let(:user) { create(:user, role: 'general_manager') }

      it { is_expected.to_not permit_action(:new)}
      it { is_expected.to_not permit_action(:create)}
    end

    context 'loan_officer' do
      let(:user) { create(:user, role: 'loan_officer') }

      it { is_expected.to_not permit_action(:new)}
      it { is_expected.to_not permit_action(:create)}
    end

    context 'teller' do
      let(:user) { create(:user, role: 'teller') }

      it { is_expected.to_not permit_action(:new)}
      it { is_expected.to_not permit_action(:create)}
    end
    context 'bookkeeper' do
      let(:user) { create(:user, role: 'bookkeeper') }

      it { is_expected.to permit_action(:new)}
      it { is_expected.to permit_action(:create)}
    end

    context 'accountant' do
      let(:user) { create(:user, role: 'accountant') }

      it { is_expected.to permit_action(:new)}
      it { is_expected.to permit_action(:create)}
    end
  end
end
